import os
import sys

import renderdoc as rd


capture_path = r"C:\Users\TA001\Pictures\rdc\ds2_tar.rdc"
output_dir = os.path.dirname(os.path.abspath(__file__))
progress_path = os.path.join(output_dir, "export_progress.txt")


def progress(message):
    with open(progress_path, "a") as log:
        log.write(message + "\n")


progress("script entered")
rd.InitialiseReplay(rd.GlobalEnvironment(), [])
progress("replay initialized")

cap = rd.OpenCaptureFile()
progress("capture handle created")
result = cap.OpenFile(capture_path, "", None)
progress("OpenFile: {}".format(result))
if result != rd.ResultCode.Succeeded:
    raise RuntimeError("OpenFile failed: {}".format(result))

result, controller = cap.OpenCapture(rd.ReplayOptions(), None)
progress("OpenCapture: {}".format(result))
if result != rd.ResultCode.Succeeded:
    raise RuntimeError("OpenCapture failed: {}".format(result))

try:
    controller.SetFrameEvent(53177, True)
    progress("SetFrameEvent complete")
    pipeline = controller.GetPipelineState()
    for name, stage in (("vertex", rd.ShaderStage.Vertex), ("pixel", rd.ShaderStage.Pixel)):
        shader = pipeline.GetShaderReflection(stage)
        if shader is None:
            raise RuntimeError("No {} shader bound".format(name))
        data = bytes(shader.rawBytes)
        output_path = os.path.join(output_dir, "eid53177_{}.dxbc".format(name))
        with open(output_path, "wb") as output:
            output.write(data)
        progress("wrote {}: {} bytes".format(name, len(data)))
        print("{}: {} bytes -> {}".format(name, len(data), output_path))
finally:
    controller.Shutdown()
    cap.Shutdown()
    rd.ShutdownReplay()

sys.exit(0)
