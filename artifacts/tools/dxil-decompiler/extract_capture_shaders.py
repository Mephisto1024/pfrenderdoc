"""Export a small, diverse shader sample from RenderDoc captures.

Run with the Python 3.6 runtime and renderdoc.pyd from this RenderDoc build.
This is an offline validation helper; it never modifies the captures.
"""

import hashlib
import json
import os
import sys

import renderdoc as rd


def actions_recursive(actions):
    for action in actions:
        if action.children:
            for child in actions_recursive(action.children):
                yield child
        else:
            yield action


def export_capture(path, output_dir, limit):
    capture = rd.OpenCaptureFile()
    result = capture.OpenFile(path, "", None)
    if result != rd.ResultCode.Succeeded:
        raise RuntimeError("OpenFile failed: {}".format(result))
    result, controller = capture.OpenCapture(rd.ReplayOptions(), None)
    if result != rd.ResultCode.Succeeded:
        capture.Shutdown()
        raise RuntimeError("OpenCapture failed: {}".format(result))
    records = []
    seen = set()
    try:
        actions = list(actions_recursive(controller.GetRootActions()))
        if not actions:
            return records
        # Probe across the capture rather than only its first pass.
        step = max(1, len(actions) // limit)
        for action in actions[::step]:
            try:
                controller.SetFrameEvent(action.eventId, True)
                pipeline = controller.GetPipelineState()
                for stage_name, stage in (("pixel", rd.ShaderStage.Pixel),
                                          ("compute", rd.ShaderStage.Compute),
                                          ("vertex", rd.ShaderStage.Vertex)):
                    reflection = pipeline.GetShaderReflection(stage)
                    if reflection is None:
                        continue
                    blob = bytes(reflection.rawBytes)
                    if not blob or b"DXIL" not in blob:
                        continue
                    digest = hashlib.sha256(blob).hexdigest()
                    if digest in seen:
                        continue
                    seen.add(digest)
                    filename = "{}_eid{}_{}_{}.dxil".format(
                        os.path.splitext(os.path.basename(path))[0],
                        action.eventId, stage_name, digest[:12])
                    dest = os.path.join(output_dir, filename)
                    with open(dest, "wb") as output:
                        output.write(blob)
                    records.append({"capture": os.path.basename(path),
                                    "eid": action.eventId, "stage": stage_name,
                                    "sha256": digest, "path": dest,
                                    "bytes": len(blob)})
                    print("{}: EID {} {} {} bytes".format(
                        os.path.basename(path), action.eventId, stage_name, len(blob)), flush=True)
                    if len(records) >= limit:
                        return records
            except Exception as error:
                print("EID {}: {}".format(action.eventId, error), file=sys.stderr, flush=True)
    finally:
        controller.Shutdown()
        capture.Shutdown()
    return records


def main():
    if len(sys.argv) < 4:
        print("Usage: extract_capture_shaders.py <output_dir> <limit_per_capture> <capture.rdc>...", file=sys.stderr)
        return 2
    output_dir = os.path.abspath(sys.argv[1])
    limit = int(sys.argv[2])
    os.makedirs(output_dir, exist_ok=True)
    rd.InitialiseReplay(rd.GlobalEnvironment(), [])
    all_records = []
    try:
        for path in sys.argv[3:]:
            print("Opening {}".format(path), flush=True)
            try:
                all_records.extend(export_capture(path, output_dir, limit))
            except Exception as error:
                print("{}: {}".format(path, error), file=sys.stderr, flush=True)
    finally:
        rd.ShutdownReplay()
    with open(os.path.join(output_dir, "manifest.json"), "w") as output:
        json.dump(all_records, output, indent=2)
    return 0 if all_records else 1


if __name__ == "__main__":
    sys.exit(main())
