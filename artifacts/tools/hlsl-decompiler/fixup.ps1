# RenderDoc fixup pass for 3Dmigoto decompiler output.
#
# 3Dmigoto emits, for a DXBC `resinfo` instruction:
#
#     t2.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
#     r0.z = uiDest.w;                       <-- reads a component that was never written
#
# The mip count is returned through the THIRD out-parameter of GetDimensions (the first
# two are width and height), so it lands in uiDest.z while the following line reads uiDest.w.
# The value is simply undefined. fxc reports it as X4000, and because RenderDoc compiles
# replacement shaders with D3DCOMPILE_WARNINGS_ARE_ERRORS (see
# renderdoc/driver/d3d11/d3d11_shader_cache.cpp), that warning becomes a fatal error:
#
#     error X4000: variable 'uiDest' used without having been completely initialized
#
# This pass rewrites the read so it consumes the component GetDimensions actually wrote.
# It only fires when every GetDimensions call in the file agrees on one slot and that slot
# is not already .w; otherwise it leaves the text untouched and warns on stderr.

param([Parameter(Mandatory = $true)][string]$Path)

$ErrorActionPreference = 'Stop'

$enc = New-Object System.Text.UTF8Encoding($false)
$text = [System.IO.File]::ReadAllText($Path, $enc)

$callRx = [regex]'GetDimensions\s*\(\s*[^,()]+,\s*uiDest\.[xyzw]\s*,\s*uiDest\.[xyzw]\s*,\s*uiDest\.(?<slot>[xyzw])\s*\)'
$slots = @($callRx.Matches($text) | ForEach-Object { $_.Groups['slot'].Value } | Sort-Object -Unique)

if ($slots.Count -eq 0) {
    [Console]::Error.WriteLine('HLSLDecompiler fixup: no uiDest GetDimensions call found, passing output through unchanged.')
}
elseif ($slots.Count -gt 1) {
    [Console]::Error.WriteLine("HLSLDecompiler fixup: GetDimensions writes different uiDest slots ($($slots -join ', ')); not rewriting, output may fail to recompile.")
}
elseif ($slots[0] -eq 'w') {
    # already consistent, nothing to do
}
elseif ($text -notmatch 'uiDest\.w') {
    # nothing reads the unwritten component
}
else {
    # Every GetDimensions call uses slot $slots[0], so any remaining uiDest.w is a read.
    $text = $text -replace 'uiDest\.w', "uiDest.$($slots[0])"
    [Console]::Error.WriteLine("HLSLDecompiler fixup: GetDimensions writes the mip count to uiDest.$($slots[0]) but the decompiled code read uiDest.w; rewrote the read.")
}

# Write the exact bytes to stdout; RenderDoc captures stdout as the HLSL result.
$bytes = $enc.GetBytes($text)
$stdout = [Console]::OpenStandardOutput()
$stdout.Write($bytes, 0, $bytes.Length)
$stdout.Flush()
