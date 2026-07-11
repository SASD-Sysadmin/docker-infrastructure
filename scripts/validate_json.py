#!/usr/bin/env python3
"""Parse every tracked JSON file without traversing Git object storage."""
from __future__ import annotations

import json
import pathlib
import subprocess

ROOT = pathlib.Path(__file__).resolve().parents[1]
raw = subprocess.check_output(
    ["git", "-C", str(ROOT), "ls-files", "-z", "--", "*.json"]
)
paths = [ROOT / item.decode("utf-8") for item in raw.split(b"\0") if item]
for path in paths:
    json.loads(path.read_text(encoding="utf-8"))
print(f"JSON validation passed for {len(paths)} tracked file(s).")
