"""Compare EID 5405's compute UAV output before and after HLSL replacement."""

import hashlib
import sys

import renderdoc as rd


CAPTURE = r"C:\Users\TA001\Pictures\rdc\yuanshen\ssr04.rdc"
EID = 5405
ORIGINAL_DXBC = r"D:\pfrenderdoc\artifacts\eid5405\compute.dxbc"


def digest(data):
    return hashlib.sha256(data).hexdigest()


def main(source_path):
    with open(source_path, "rb") as stream:
        source = stream.read()

    rd.InitialiseReplay(rd.GlobalEnvironment(), [])
    capture = rd.OpenCaptureFile()
    result = capture.OpenFile(CAPTURE, "", None)
    if result != rd.ResultCode.Succeeded:
        raise RuntimeError("OpenFile: {}".format(result))
    result, controller = capture.OpenCapture(rd.ReplayOptions(), None)
    if result != rd.ResultCode.Succeeded:
        raise RuntimeError("OpenCapture: {}".format(result))

    original_id = rd.ResourceId.Null()
    replacement_id = rd.ResourceId.Null()
    try:
        controller.SetFrameEvent(EID, True)
        pipeline = controller.GetPipelineState()
        shader = pipeline.GetShaderReflection(rd.ShaderStage.Compute)
        original_id = shader.resourceId
        with open(ORIGINAL_DXBC, "rb") as stream:
            saved_bytecode = stream.read()
        if bytes(shader.rawBytes) != saved_bytecode:
            raise RuntimeError("saved DXBC does not match EID 5405's compute shader")
        print("source DXBC verified: {} bytes {}".format(
            len(saved_bytecode), digest(saved_bytecode)), flush=True)
        uavs = pipeline.GetReadWriteResources(rd.ShaderStage.Compute)
        texture_ids = {desc.resourceId for desc in controller.GetTextures()}
        buffer_ids = {desc.resourceId for desc in controller.GetBuffers()}
        targets = []
        buffers = []
        for uav in uavs:
            d = uav.descriptor
            if d.resource in buffer_ids and d.resource not in buffers:
                buffers.append(d.resource)
            if d.resource not in texture_ids:
                continue
            if d.firstMip < 6 and d.numMips > 0:
                target = (d.resource, d.firstMip)
                if target not in targets:
                    targets.append(target)
        print("UAV texture subresources: {}".format(len(targets)), flush=True)
        originals = {}
        for target_id, mip in targets:
            data = bytes(controller.GetTextureData(target_id, rd.Subresource(mip, 0, 0)))
            originals[(target_id, mip)] = data
            print("baseline mip {}: {} bytes {}".format(mip, len(data), digest(data)), flush=True)
        original_buffers = {}
        for buffer_id in buffers:
            data = bytes(controller.GetBufferData(buffer_id, 0, 0))
            original_buffers[buffer_id] = data
            print("baseline buffer: {} bytes {}".format(len(data), digest(data)), flush=True)

        controller.SetFrameEvent(EID - 1, True)
        before = {}
        for target_id, mip in targets:
            before[(target_id, mip)] = bytes(
                controller.GetTextureData(target_id, rd.Subresource(mip, 0, 0)))
        before_buffers = {buffer_id: bytes(controller.GetBufferData(buffer_id, 0, 0))
                          for buffer_id in buffers}
        controller.SetFrameEvent(EID, True)
        for target_id, mip in targets:
            changed = sum(a != b for a, b in zip(before[(target_id, mip)],
                                                  originals[(target_id, mip)]))
            print("event wrote mip {}: {} bytes changed".format(mip, changed), flush=True)
        for buffer_id in buffers:
            changed = sum(a != b for a, b in zip(before_buffers[buffer_id],
                                                 original_buffers[buffer_id]))
            print("event wrote buffer: {} bytes changed".format(changed), flush=True)
        for target_id, mip in targets:
            again = bytes(controller.GetTextureData(target_id, rd.Subresource(mip, 0, 0)))
            if again != originals[(target_id, mip)]:
                raise RuntimeError("baseline mip {} is not reproducible".format(mip))
        for buffer_id in buffers:
            again = bytes(controller.GetBufferData(buffer_id, 0, 0))
            if again != original_buffers[buffer_id]:
                raise RuntimeError("baseline buffer is not reproducible")

        flags = rd.ShaderCompileFlags()
        profile = rd.ShaderCompileFlag()
        profile.name = "@cmdline"
        profile.value = "-T cs_5_0"
        flags.flags.append(profile)
        replacement_id, messages = controller.BuildTargetShader(
            "main", rd.ShaderEncoding.HLSL, source, flags, rd.ShaderStage.Compute)
        print("BuildTargetShader: {}".format(messages), flush=True)
        if replacement_id == rd.ResourceId.Null():
            raise RuntimeError("BuildTargetShader failed")

        controller.ReplaceResource(original_id, replacement_id)
        controller.SetFrameEvent(EID, True)
        mismatches = 0
        for target_id, mip in targets:
            after = bytes(controller.GetTextureData(target_id, rd.Subresource(mip, 0, 0)))
            before = originals[(target_id, mip)]
            changed = sum(a != b for a, b in zip(before, after))
            print("replacement mip {}: {} bytes {} changed_bytes={}".format(
                mip, len(after), digest(after), changed), flush=True)
            mismatches += int(changed != 0)
        for buffer_id in buffers:
            after = bytes(controller.GetBufferData(buffer_id, 0, 0))
            before = original_buffers[buffer_id]
            changed = sum(a != b for a, b in zip(before, after))
            print("replacement buffer: {} bytes {} changed_bytes={}".format(
                len(after), digest(after), changed), flush=True)
            mismatches += int(changed != 0)
        print("RESULT: {} of {} resources differ".format(
            mismatches, len(targets) + len(buffers)), flush=True)
        return int(mismatches != 0)
    finally:
        if original_id != rd.ResourceId.Null():
            controller.RemoveReplacement(original_id)
        if replacement_id != rd.ResourceId.Null():
            controller.FreeTargetResource(replacement_id)
        controller.Shutdown()
        capture.Shutdown()
        rd.ShutdownReplay()


if __name__ == "__main__":
    sys.exit(main(sys.argv[1]))
