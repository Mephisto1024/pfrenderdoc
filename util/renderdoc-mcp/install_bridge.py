"""Install the vendored MCP bridge into a RenderDoc GUI profile."""

import argparse
import datetime
import hashlib
import json
import os
import shutil
from pathlib import Path


BRIDGE_NAME = "renderdoc_mcp_bridge"


def profile_dir(app_name):
    if os.name == "nt":
        appdata = os.environ.get("APPDATA")
        if not appdata:
            raise RuntimeError("APPDATA is not set")
        return Path(appdata) / app_name
    data_home = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))
    return data_home / app_name


def same_bridge(source, installed):
    for path in source.rglob("*"):
        if not path.is_file():
            continue
        if "__pycache__" in path.parts or path.suffix in (".pyc", ".pyo"):
            continue
        target = installed / path.relative_to(source)
        if not target.is_file():
            return False
        if hashlib.sha256(path.read_bytes()).digest() != hashlib.sha256(target.read_bytes()).digest():
            return False
    return True


def backup_name(path):
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    return path.with_name(path.name + ".backup-" + stamp)


def install_bridge(source, extensions, replace):
    target = extensions / BRIDGE_NAME
    extensions.mkdir(parents=True, exist_ok=True)

    if target.exists():
        if target.is_symlink() or not target.is_dir():
            raise RuntimeError("Bridge target is not a normal directory: " + str(target))
        if same_bridge(source, target):
            print("Bridge already installed:", target)
            return
        if not replace:
            raise RuntimeError(
                "A different bridge exists at {}. Re-run with --replace to back it up and install this version.".format(target)
            )
        # Only rename the exact child of this profile's extensions directory.
        if target.resolve().parent != extensions.resolve():
            raise RuntimeError("Bridge target resolves outside the extension directory")
        backup_dir = extensions.parent / "mcp-bridge-backups"
        if backup_dir.resolve().parent != extensions.resolve().parent:
            raise RuntimeError("Backup directory resolves outside the GUI profile")
        backup_dir.mkdir(parents=True, exist_ok=True)
        backup = backup_dir / backup_name(target).name
        target.rename(backup)
        print("Previous bridge backed up to:", backup)
        try:
            shutil.copytree(source, target, ignore=shutil.ignore_patterns("__pycache__", "*.pyc", "*.pyo"))
        except Exception:
            if target.exists():
                if target.is_symlink() or target.resolve().parent != extensions.resolve():
                    raise RuntimeError("Partial bridge resolves outside the extension directory")
                shutil.rmtree(target)
            backup.rename(target)
            raise
    else:
        shutil.copytree(source, target, ignore=shutil.ignore_patterns("__pycache__", "*.pyc", "*.pyo"))
    print("Bridge installed:", target)


def enable_autoload(config_path):
    if config_path.exists():
        with config_path.open("r", encoding="utf-8-sig") as handle:
            config = json.load(handle)
        if not isinstance(config, dict):
            raise RuntimeError("UI.config is not a JSON object: " + str(config_path))
    else:
        config = {}

    extensions = config.get("AlwaysLoad_Extensions", [])
    if not isinstance(extensions, list):
        raise RuntimeError("AlwaysLoad_Extensions is not a list: " + str(config_path))
    if BRIDGE_NAME in extensions:
        print("Bridge already enabled in:", config_path)
        return

    config["AlwaysLoad_Extensions"] = extensions + [BRIDGE_NAME]
    if config_path.exists():
        backup = backup_name(config_path)
        shutil.copy2(config_path, backup)
        print("UI config backed up to:", backup)
    config_path.parent.mkdir(parents=True, exist_ok=True)
    temporary = config_path.with_name(config_path.name + ".mcp-tmp")
    try:
        temporary.write_text(json.dumps(config, ensure_ascii=False, indent=4) + "\n", encoding="utf-8")
        temporary.replace(config_path)
    finally:
        if temporary.exists():
            temporary.unlink()
    print("Bridge enabled in:", config_path)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--app", choices=("qrendertest", "qrenderdoc"), default="qrendertest")
    parser.add_argument("--replace", action="store_true", help="Back up and replace a different bridge installation")
    args = parser.parse_args()

    source = Path(__file__).resolve().parent / "renderdoc_extension"
    profile = profile_dir(args.app)
    install_bridge(source, profile / "extensions", args.replace)
    enable_autoload(profile / "UI.config")
    print("Restart {} before using the MCP server.".format(args.app))


if __name__ == "__main__":
    main()
