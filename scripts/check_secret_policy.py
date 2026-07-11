#!/usr/bin/env python3
"""Reject private keys and likely plaintext credentials in tracked content."""
from __future__ import annotations

import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
try:
    files = subprocess.check_output(
        ["git", "-C", str(ROOT), "ls-files", "-z"]
    ).split(b"\0")
    paths = [ROOT / pathlib.Path(item.decode("utf-8")) for item in files if item]
except Exception:
    paths = [path for path in ROOT.rglob("*") if path.is_file() and ".git" not in path.parts]

failures: list[str] = []
private_markers = tuple(
    ("BEGIN" + ((" " + kind) if kind else "") + " PRIVATE KEY").encode()
    for kind in ("", "RSA", "OPENSSH", "EC")
)
assignment = re.compile(
    r"^[ \t]*[\"\']?(?P<key>[A-Za-z0-9_.:-]+)[\"\']?[ \t]*(?::|=>|=)[ \t]*(?P<value>.*)$",
    re.IGNORECASE,
)
credential_extensions = {".yaml", ".yml", ".json", ".eyaml", ".ini", ".conf", ".env", ".properties"}
secret_suffixes = ("password", "passwd", "secret", "token", "api_key", "api-key")

block_markers = {">", "|", ">-", "|-", ">+", "|+"}
safe_literals = {"", "null", "~", "REDACTED", "CHANGEME"}


def normalize(value: str) -> str:
    return value.strip().strip('"\'').strip()


def encrypted_or_placeholder(value: str) -> bool:
    compact = "".join(value.split())
    return compact.startswith("ENC[PKCS7,") or compact in {
        "REPLACE_WITH_REAL_ENCRYPTED_VALUE",
        "ENC[PKCS7,...]",
    }


def is_secret_key(key: str) -> bool:
    normalized = key.lower().replace("::", "_").replace(".", "_").replace(":", "_")
    return any(normalized == suffix or normalized.endswith("_" + suffix) for suffix in secret_suffixes)


for path in paths:
    rel = path.relative_to(ROOT)
    if any(part in {"vendor", "modules", "dist"} for part in rel.parts):
        continue
    try:
        raw = path.read_bytes()
    except OSError:
        continue
    if any(marker in raw for marker in private_markers):
        failures.append(f"{rel}: private key material")
    if path.suffix.lower() in {".pem", ".key", ".p12", ".pfx", ".jks", ".keystore"}:
        failures.append(f"{rel}: forbidden secret-bearing extension")
    if b"\0" in raw:
        continue
    if path.suffix.lower() not in credential_extensions:
        continue

    lines = raw.decode("utf-8", "replace").splitlines()
    for index, line in enumerate(lines):
        stripped = line.lstrip()
        if stripped.startswith("#"):
            continue
        match = assignment.match(line)
        if not match or not is_secret_key(match.group("key")):
            continue
        value = normalize(match.group("value"))
        if value in safe_literals or encrypted_or_placeholder(value):
            continue
        if value in block_markers:
            base_indent = len(line) - len(line.lstrip(" \t"))
            block: list[str] = []
            for following in lines[index + 1 :]:
                if not following.strip():
                    continue
                indent = len(following) - len(following.lstrip(" \t"))
                if indent <= base_indent:
                    break
                block.append(following.strip())
            if block and encrypted_or_placeholder("".join(block)):
                continue
        failures.append(
            f"{rel}:{index + 1}: likely plaintext credential key {match.group('key')}"
        )

if failures:
    print("\n".join("ERROR: " + item for item in sorted(set(failures))), file=sys.stderr)
    raise SystemExit(1)
print(f"Secret policy passed for {len(paths)} tracked file(s).")
