# RenderDoc MCP for QRenderTest

This directory vendors [halby24/RenderDocMCP](https://github.com/halby24/RenderDocMCP)
at commit `11b6b74` (MIT license in `LICENSE`). The original MCP server and RenderDoc
extension are included so a normal clone of this repository contains the source.

Project changes:

- The file IPC directory defaults to `rendertest_mcp` so this fork can run beside
  an official RenderDoc installation. Set `RENDERDOC_MCP_IPC_DIR` in both the GUI
  and MCP server environments to override it.
- The bridge uses RenderDoc's `MiniQtHelper.InvokeOntoUIThread` and the standard
  Python `threading` module, so PySide2 is not required by this fork's GUI build.
- `install_bridge.py` installs the extension into the `qrendertest` profile and
  enables automatic loading. It also supports `--app qrenderdoc`.
- `setup.ps1` creates a local Python environment from `uv.lock` and installs the
  GUI extension. The environment is ignored by Git.

From a PowerShell session at the repository root, run
`& "$PSHOME\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File .\util\renderdoc-mcp\setup.ps1`.
See [the full setup guide](../../docs/renderdoc-mcp.md).
