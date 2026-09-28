# RenderDoc MCP 接入

本仓库内置 [halby24/RenderDocMCP](https://github.com/halby24/RenderDocMCP)
的源码，固定在提交 `11b6b74`。MCP 服务端通过文件 IPC 与 RenderDoc 的 Python
扩展通信，可查询捕获文件的事件、帧摘要、管线、Shader、纹理和缓冲区。
上游 MIT 许可证和本仓库的适配说明见 [`util/renderdoc-mcp/README.md`](../util/renderdoc-mcp/README.md)。

## Windows 首次配置

1. [构建本仓库](CONTRIBUTING/Compiling.md)的 `qrendertest.exe`，或准备好本项目发布的构建。需要本机安装
   [uv](https://docs.astral.sh/uv/getting-started/installation/)；首次运行会安装
   Python 3.12 和 `uv.lock` 固定的 Python 依赖。
2. 关闭正在运行的 `qrendertest.exe`，在仓库根目录执行：

   ```powershell
   & "$PSHOME\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File .\util\renderdoc-mcp\setup.ps1
   ```

   脚本将 Python 环境建在 `util/renderdoc-mcp/.venv`，将桥接扩展复制到
   `%APPDATA%\qrendertest\extensions\renderdoc_mcp_bridge`，并加入
   `%APPDATA%\qrendertest\UI.config` 的 `AlwaysLoad_Extensions`。
   已有不同版本扩展时，脚本会停止并提示；确认要替换时运行
   `setup.ps1 -ReplaceExisting`，旧目录会先备份到
   `%APPDATA%\qrendertest\mcp-bridge-backups`。
3. 启动 `qrendertest.exe` 并打开 `.rdc` 文件。GUI 必须保持运行，MCP 才能读取捕获。

本仓库的 Codex 项目配置在 [`.codex/config.toml`](../.codex/config.toml)。
在仓库根目录启动 Codex 并信任该项目后，MCP 服务 `rendertest_capture`
会使用仓库内的 `uv.lock` 启动。若 Codex 已在运行，重新打开该项目聊天。
Codex [仅对受信任项目加载项目级配置](https://learn.chatgpt.com/docs/config-file/config-basic)；
可以用 `codex mcp list` 查看注册状态。

其他 MCP 客户端可使用 stdio，命令为：

```powershell
uv run --project .\util\renderdoc-mcp --locked --python 3.12 renderdoc-mcp
```

此命令应从仓库根目录运行。服务端启动后，先用 `get_capture_status`
确认 GUI 已加载捕获，再调用 `get_frame_summary`、`get_draw_calls` 等工具。
要连接官方 `qrenderdoc`，可改用 `setup.ps1 -App qrenderdoc`；已有不同版本
桥接扩展时需显式添加 `-ReplaceExisting`。本次端到端验证使用的是本项目的
`qrendertest.exe`。请避免让两个 GUI 同时使用同一 IPC 目录。
桥接使用固定的请求和响应文件，同一时刻只连接一个 MCP 客户端。

捕获文件和本地 Python 环境不需要提交到 Git。MCP 服务端及 GUI 扩展
通过本地临时目录传递请求；MCP 客户端如何处理返回的信息由客户端决定。
