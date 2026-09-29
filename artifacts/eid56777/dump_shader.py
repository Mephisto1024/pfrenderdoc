"""Dump the shaders bound at a capture event, so they can be decompiled offline.

Usage: dump_shader.py <capture.rdc> <eid> <output-dir>

Run with the Python 3.6 runtime from this repository - renderdoc.pyd links against PYTHON36.dll.
"""

import os
import sys

import renderdoc as rd


def main():
    if len(sys.argv) != 4:
        print("Usage: dump_shader.py <capture.rdc> <eid> <output-dir>", file=sys.stderr)
        return 2

    capture_path, eid_text, output_dir = sys.argv[1:]
    eid = int(eid_text)

    if not os.path.isdir(output_dir):
        os.makedirs(output_dir)

    rd.InitialiseReplay(rd.GlobalEnvironment(), [])
    capture = rd.OpenCaptureFile()
    result = capture.OpenFile(capture_path, "", None)
    if result != rd.ResultCode.Succeeded:
        raise RuntimeError("OpenFile: {}".format(result))

    result, controller = capture.OpenCapture(rd.ReplayOptions(), None)
    if result != rd.ResultCode.Succeeded:
        raise RuntimeError("OpenCapture: {}".format(result))

    try:
        controller.SetFrameEvent(eid, True)
        pipeline = controller.GetPipelineState()

        print("Capture: {}".format(capture_path))
        print("EID: {}".format(eid))

        found = False
        for name, stage in (("vertex", rd.ShaderStage.Vertex),
                            ("pixel", rd.ShaderStage.Pixel),
                            ("compute", rd.ShaderStage.Compute)):
            shader = pipeline.GetShaderReflection(stage)
            if shader is None:
                continue
            found = True

            data = bytes(shader.rawBytes)
            output_path = os.path.join(output_dir, "eid{}_{}.bin".format(eid, name))
            with open(output_path, "wb") as output:
                output.write(data)

            print("{}: entry '{}' encoding {} ({} bytes)".format(
                name, shader.entryPoint, shader.encoding, len(data)))
            print("    raw bytes -> {}".format(output_path))

            flags = ", ".join("{}={}".format(flag.name, flag.value)
                              for flag in shader.debugInfo.compileFlags.flags)
            print("    compile flags: {}".format(flags if flags else "(none)"))
            print("    inputs {} outputs {} constant blocks {} samplers {} read-only {} read-write {}"
                  .format(len(shader.inputSignature), len(shader.outputSignature),
                          len(shader.constantBlocks), len(shader.samplers),
                          len(shader.readOnlyResources), len(shader.readWriteResources)))

        if not found:
            print("No shader stages bound at this event.")

        targets = [target.resource for target in pipeline.GetOutputTargets()
                   if target.resource != rd.ResourceId.Null()]
        print("Output targets: {}".format(len(targets)))
    finally:
        controller.Shutdown()
        capture.Shutdown()
        rd.ShutdownReplay()

    return 0


if __name__ == "__main__":
    sys.exit(main())
