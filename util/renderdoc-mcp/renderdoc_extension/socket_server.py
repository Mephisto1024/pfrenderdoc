"""File-based IPC bridge that works without optional PySide2 bindings."""

import json
import os
import tempfile
import threading
import time
import traceback


# Keep the fork's bridge separate from an official qrenderdoc installation.
# The same override is read by mcp_server/bridge/client.py.
IPC_DIR = os.environ.get(
    "RENDERDOC_MCP_IPC_DIR", os.path.join(tempfile.gettempdir(), "rendertest_mcp")
)
REQUEST_FILE = os.path.join(IPC_DIR, "request.json")
RESPONSE_FILE = os.path.join(IPC_DIR, "response.json")
RESPONSE_TEMP_FILE = os.path.join(IPC_DIR, "response.json.tmp")
LOCK_FILE = os.path.join(IPC_DIR, "lock")


class MCPBridgeServer:
    """Poll files in a worker, then handle RenderDoc calls on the UI thread."""

    def __init__(self, host, port, handler, context):
        self.handler = handler
        self._ui = context.Extensions().GetMiniQtHelper()
        self._running = False
        self._busy = False
        self._thread = None
        if not os.path.exists(IPC_DIR):
            os.makedirs(IPC_DIR)

    def start(self):
        self._cleanup_files()
        self._running = True
        self._thread = threading.Thread(target=self._poll_loop, name="renderdoc-mcp-bridge")
        self._thread.daemon = True
        self._thread.start()
        print("[MCP Bridge] File-based IPC server started")
        print("[MCP Bridge] IPC directory: %s" % IPC_DIR)
        return True

    def stop(self):
        self._running = False
        if self._thread and self._thread is not threading.current_thread():
            self._thread.join(1.0)
        self._thread = None
        self._cleanup_files()
        print("[MCP Bridge] Server stopped")

    def is_running(self):
        return self._running

    def _cleanup_files(self):
        for path in (REQUEST_FILE, RESPONSE_FILE, RESPONSE_TEMP_FILE, LOCK_FILE):
            try:
                if os.path.exists(path):
                    os.remove(path)
            except Exception:
                pass

    def _poll_loop(self):
        while self._running:
            if not self._busy and os.path.exists(REQUEST_FILE) and not os.path.exists(LOCK_FILE):
                try:
                    with open(REQUEST_FILE, "r", encoding="utf-8") as handle:
                        request = json.load(handle)
                    os.remove(REQUEST_FILE)
                    self._busy = True
                    # The RenderDoc capture context must only be used on its UI thread.
                    self._ui.InvokeOntoUIThread(lambda req=request: self._handle_on_ui_thread(req))
                except Exception as exc:
                    self._busy = False
                    print("[MCP Bridge] Error reading request: %s" % exc)
                    traceback.print_exc()
            time.sleep(0.1)

    def _handle_on_ui_thread(self, request):
        if not self._running:
            self._busy = False
            return
        try:
            try:
                response = self.handler.handle(request)
            except Exception as exc:
                traceback.print_exc()
                response = {
                    "id": request.get("id"),
                    "error": {"code": -32603, "message": str(exc)},
                }
            with open(RESPONSE_TEMP_FILE, "w", encoding="utf-8") as handle:
                json.dump(response, handle)
            os.replace(RESPONSE_TEMP_FILE, RESPONSE_FILE)
        except Exception as exc:
            print("[MCP Bridge] Error processing request: %s" % exc)
            traceback.print_exc()
        finally:
            self._busy = False
