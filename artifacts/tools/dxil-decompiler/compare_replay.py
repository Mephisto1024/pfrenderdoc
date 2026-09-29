"""Compare a capture event's render targets before/after a pixel shader replacement.

Run with the Python 3.6 runtime from this repository - renderdoc.pyd links against PYTHON36.dll,
so no other interpreter will load it:

    set PATH=D:\\pfrenderdoc\\x64\\Release;%PATH%
    artifacts\\tools\\py36\\python.exe artifacts\\tools\\dxil-decompiler\\compare_replay.py \
        <capture.rdc> <eid> <pixel.hlsl>

Why the comparison decodes values instead of counting differing bytes: these targets are 16-bit
and float formats, where a one-step change in the high byte of a uint16 is 256x a one-step change
in the low byte, and a one-bit change in a float exponent dwarfs any mantissa change. A raw
differing-byte count over such data cannot distinguish "one LSB of rounding" from "a different
colour", so a byte histogram would be actively misleading.
"""

import hashlib
import struct
import sys

import renderdoc as rd


def decode(data, format_name):
    """Decode raw render target bytes into per-channel floats, or None if unsupported."""
    if format_name.startswith("R8G8B8A8"):
        return [value / 255.0 for value in data]

    if format_name == "R16G16_UNORM":
        count = len(data) // 4
        values = struct.unpack("<{}H".format(count * 2), data[:count * 4])
        return [value / 65535.0 for value in values]

    if format_name in ("R16G16_FLOAT", "R16G16_SFLOAT"):
        count = len(data) // 4
        return list(struct.unpack("<{}e".format(count * 2), data[:count * 4]))

    if format_name == "R16G16_SINT":
        count = len(data) // 4
        return list(struct.unpack("<{}h".format(count * 2), data[:count * 4]))

    return None


def channels_per_pixel(format_name):
    if format_name.startswith("R8G8B8A8"):
        return 4
    if format_name.startswith("R16G16"):
        return 2
    return 0


def report_differences(index, original, replaced, format_name):
    """Print how far apart two render targets are. Returns the number of differing channels."""
    decoded_original = decode(original, format_name)
    decoded_replaced = decode(replaced, format_name)

    if decoded_original is None:
        different = sum(a != b for a, b in zip(original, replaced))
        print("  MISMATCH: target {} differs in {} of {} raw bytes ({} is not decoded, so the "
              "magnitude is unknown)".format(index, different, len(original), format_name),
              flush=True)
        return 1

    diffs = [abs(a - b) for a, b in zip(decoded_original, decoded_replaced)]
    affected = [position for position, delta in enumerate(diffs) if delta > 0.0]

    if not affected:
        print("  MATCH: target {} is numerically identical".format(index), flush=True)
        return 0

    channels = channels_per_pixel(format_name)
    worst = max(diffs)
    worst_position = diffs.index(worst)
    # The resolution a human could actually see in an 8-bit display.
    visible = sum(1 for delta in diffs if delta > 1.0 / 255.0)
    rounding = len(affected) - visible

    print("  MISMATCH: target {} differs in {} of {} channels".format(
        index, len(affected), len(diffs)), flush=True)
    if channels:
        print("    worst channel: pixel {} channel {}, delta {:.6f}".format(
            worst_position // channels, worst_position % channels, worst), flush=True)
    else:
        print("    worst channel index {}, delta {:.6f}".format(worst_position, worst), flush=True)
    print("    {} channel(s) differ by > 1/255 (visible in 8-bit), "
          "{} differ by less (rounding)".format(visible, rounding), flush=True)
    return len(affected)


def main():
    if len(sys.argv) != 4:
        print("Usage: compare_replay.py <capture.rdc> <eid> <pixel.hlsl>", file=sys.stderr)
        return 2
    capture_path, eid_text, source_path = sys.argv[1:]
    eid = int(eid_text)
    with open(source_path, "rb") as input_file:
        source = input_file.read()

    rd.InitialiseReplay(rd.GlobalEnvironment(), [])
    capture = rd.OpenCaptureFile()
    result = capture.OpenFile(capture_path, "", None)
    if result != rd.ResultCode.Succeeded:
        raise RuntimeError("OpenFile: {}".format(result))
    result, controller = capture.OpenCapture(rd.ReplayOptions(), None)
    if result != rd.ResultCode.Succeeded:
        raise RuntimeError("OpenCapture: {}".format(result))
    compiled_id = rd.ResourceId.Null()
    original_id = rd.ResourceId.Null()
    try:
        controller.SetFrameEvent(eid, True)
        pipeline = controller.GetPipelineState()
        shader = pipeline.GetShaderReflection(rd.ShaderStage.Pixel)
        if shader is None:
            raise RuntimeError("No pixel shader at EID {}".format(eid))
        targets = [target.resource for target in pipeline.GetOutputTargets()
                   if target.resource != rd.ResourceId.Null()]
        if not targets:
            raise RuntimeError("No color render target at EID {}".format(eid))
        original_id = shader.resourceId

        descriptions = {}
        for texture in controller.GetTextures():
            descriptions[texture.resourceId] = texture

        formats = []
        originals = []
        for index, target_id in enumerate(targets):
            description = descriptions.get(target_id)
            if description is None:
                format_name = "Unknown"
                print("Target {}: no texture description available".format(index), flush=True)
            else:
                try:
                    format_name = description.format.Name()
                except Exception:
                    format_name = str(description.format)
                print("Target {}: {}x{} format {}".format(
                    index, description.width, description.height, format_name), flush=True)
            formats.append(format_name)
            data = bytes(controller.GetTextureData(target_id, rd.Subresource()))
            originals.append(data)
            print("Original target {}: {} bytes SHA256 {}".format(
                index, len(data), hashlib.sha256(data).hexdigest()), flush=True)

        # Confirm the event actually writes these targets. Without this, an identical comparison
        # after the replacement would prove nothing - the bytes might simply never be touched.
        written = []
        for index, target_id in enumerate(targets):
            controller.SetFrameEvent(eid - 1, True)
            before = bytes(controller.GetTextureData(target_id, rd.Subresource()))
            controller.SetFrameEvent(eid, True)
            changed = sum(a != b for a, b in zip(before, originals[index]))
            written.append(changed)
            print("Target {} written by this event: {} bytes changed".format(index, changed),
                  flush=True)

        # Read the baseline a second time. A render target that is only partly written by this
        # event, or that holds data from a pass that replays with any variance, does not reproduce
        # between reads - and comparing a replacement against a baseline that is itself unstable
        # proves nothing. Measured on a deferred lighting pass: its first target gave a different
        # hash on every replay while the others were stable.
        unstable = set()
        for index, target_id in enumerate(targets):
            again = bytes(controller.GetTextureData(target_id, rd.Subresource()))
            if again != originals[index]:
                unstable.add(index)
                print("Target {}: BASELINE NOT REPRODUCIBLE - reading it twice in the same session "
                      "gave different bytes, so this target cannot be compared".format(index),
                      flush=True)

        flags = rd.ShaderCompileFlags()
        profile = rd.ShaderCompileFlag()
        profile.name = "@cmdline"
        profile.value = "-T ps_6_6"
        flags.flags.append(profile)
        compiled_id, messages = controller.BuildTargetShader(
            "main", rd.ShaderEncoding.HLSL, source, flags, rd.ShaderStage.Pixel)
        print("BuildTargetShader: {}".format(messages), flush=True)
        if compiled_id == rd.ResourceId.Null():
            raise RuntimeError("BuildTargetShader failed")

        controller.ReplaceResource(original_id, compiled_id)
        controller.SetFrameEvent(eid, True)

        mismatches = 0
        checked = 0
        orphaned = 0
        unstable_count = 0
        for index, target_id in enumerate(targets):
            replaced = bytes(controller.GetTextureData(target_id, rd.Subresource()))
            print("Replaced target {}: {} bytes SHA256 {}".format(
                index, len(replaced), hashlib.sha256(replaced).hexdigest()), flush=True)
            if not written[index]:
                print("  SKIPPED: this event does not write target {}, so an identical "
                      "comparison would prove nothing".format(index), flush=True)
                if replaced != originals[index]:
                    print("  (it also differs even though it is not written here - the "
                          "replacement affects other events)", flush=True)
                    orphaned += 1
                continue
            if index in unstable:
                print("  SKIPPED: target {}'s own baseline is not reproducible".format(index),
                      flush=True)
                unstable_count += 1
                continue
            checked += 1
            if replaced == originals[index]:
                print("  MATCH: target {} is byte-identical".format(index), flush=True)
                continue
            if len(replaced) != len(originals[index]):
                print("  MISMATCH: target {} byte length changed".format(index), flush=True)
                mismatches += 1
                continue
            if report_differences(index, originals[index], replaced, formats[index]):
                mismatches += 1

        print("RESULT: {} of {} comparable targets differ{}".format(
            mismatches, checked,
            " ({} unstable baseline(s) skipped, {} unwritten target(s) changed)".format(
                unstable_count, orphaned) if (unstable_count or orphaned) else ""))
        return 1 if mismatches else 0
    finally:
        if original_id != rd.ResourceId.Null():
            controller.RemoveReplacement(original_id)
        if compiled_id != rd.ResourceId.Null():
            controller.FreeTargetResource(compiled_id)
        controller.Shutdown()
        capture.Shutdown()
        rd.ShutdownReplay()


if __name__ == "__main__":
    sys.exit(main())
