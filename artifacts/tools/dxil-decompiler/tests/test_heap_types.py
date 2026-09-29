"""Compile HLSL fixtures, infer descriptor types from DXIL, and recompile output."""

import os
import re
import shutil
import subprocess
import sys
import uuid


CASES = {
    "ps_float4": ["Texture2D<float4>", "SamplerState"],
    "ps_float2_3d": ["Texture3D<float2>", "SamplerState"],
    "ps_uint4_load": ["Texture2D<uint4>"],
    "ps_int4_buffer": ["Buffer<int4>"],
    "ps_rw_texture": ["RWTexture2D<uint2>"],
    "ps_comparison": ["Texture2D<float>", "SamplerComparisonState"],
    "ps_nonuniform": ["Texture2D<float4>", "SamplerState"],
    "ps_raw": ["ByteAddressBuffer"],
}
UNSUPPORTED_LAYOUTS = {
    "ps_structured": "kind 12 requires layout information",
    "ps_constant_buffer": "kind 13 requires layout information",
}
ANNOTATION = re.compile(
    r"annotateHandle\([^\n]*ResourceProperties \{ i32 (-?\d+), i32 (-?\d+) \}"
    r"[^\n]*resource: ([^\r\n]+)")


class WorkspaceTempDir:
    """A scratch directory created under this test folder.

    tempfile.TemporaryDirectory creates its directory with mode 0o700, and the ACL that produces
    denies dxc the write access it needs for -Fo when the process runs under a restricted token
    (as it does inside the agent sandbox). A plain mkdir inherits the parent's permissions, which
    is all this test needs.
    """

    def __init__(self, prefix):
        base = os.path.join(os.path.dirname(os.path.abspath(__file__)), "tmp")
        self._path = os.path.join(base, prefix + uuid.uuid4().hex[:8])

    def __enter__(self):
        os.makedirs(self._path, exist_ok=True)
        return self._path

    def __exit__(self, *exc_info):
        shutil.rmtree(self._path, ignore_errors=True)
        return False


def run(*args, **kwargs):
    return subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                          universal_newlines=True, **kwargs)


def check(condition, message):
    if not condition:
        raise AssertionError(message)


def main():
    if len(sys.argv) != 3:
        print("Usage: test_heap_types.py <dxc.exe> <dxil-decompiler.exe>", file=sys.stderr)
        return 2
    dxc, decompiler = sys.argv[1:]
    source = os.path.join(os.path.dirname(__file__), "heap_types.hlsl")
    with WorkspaceTempDir("dxil-decompiler-test-") as temp:
        for entry, expected in list(CASES.items()) + list(UNSUPPORTED_LAYOUTS.items()):
            blob = os.path.join(temp, entry + ".dxil")
            compiled = run(dxc, "-T", "ps_6_6", "-E", entry, "-Fo", blob, source)
            check(compiled.returncode == 0, "{} input compilation: {}".format(entry, compiled.stderr))
            dumped = run(dxc, "-dumpbin", blob)
            check(dumped.returncode == 0, "{} dumpbin: {}".format(entry, dumped.stderr))
            annotations = ANNOTATION.findall(dumped.stdout)
            check(annotations, "{}: no descriptor annotations".format(entry))
            inferred = []
            for first, second, _comment in annotations:
                kind = int(first) & 255
                result = run(decompiler, "--infer-type", first, second,
                             "sampler" if kind == 14 else "resource")
                if entry in CASES:
                    check(result.returncode == 0, "{} inference: {}".format(entry, result.stderr))
                    inferred.append(result.stdout.strip())
                else:
                    check(result.returncode != 0, "{} should reject missing layout".format(entry))
                    check(expected in result.stderr, "{} error: {}".format(entry, result.stderr))
            if entry in CASES:
                check(sorted(inferred) == sorted(expected),
                      "{}: inferred {}, expected {}".format(entry, inferred, expected))
            disassembly = blob + ".txt"
            with open(disassembly, "w", encoding="utf-8") as output:
                output.write(dumped.stdout)
            decompiled = run(decompiler, disassembly)
            if entry in CASES:
                check(decompiled.returncode == 0, "{} decompile: {}".format(entry, decompiled.stderr))
                generated = disassembly + ".hlsl"
                if entry == "ps_nonuniform":
                    with open(generated, "r", encoding="utf-8") as input_file:
                        check("NonUniformResourceIndex(" in input_file.read(),
                              "Non-uniform index modifier was lost")
                regenerated = run(dxc, "-T", "ps_6_6", "-E", "main", "-Fo",
                                  os.path.join(temp, entry + "-roundtrip.dxil"), generated)
                check(regenerated.returncode == 0,
                      "{} roundtrip compilation: {}".format(entry, regenerated.stderr))
                print("PASS {}: {}".format(entry, ", ".join(inferred)))
            else:
                check(decompiled.returncode != 0, "{} should fail explicitly".format(entry))
                check(expected in decompiled.stderr,
                      "{} decompile error: {}".format(entry, decompiled.stderr))
                print("EXPECTED UNSUPPORTED {}: {}".format(entry, expected))
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except AssertionError as error:
        print("FAIL " + str(error), file=sys.stderr)
        sys.exit(1)
