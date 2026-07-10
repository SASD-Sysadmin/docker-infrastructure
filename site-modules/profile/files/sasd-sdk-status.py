#!/usr/bin/env python3
"""Report installed SDK commands against SASD expectation markers.

The helper is deliberately read-only. It never installs packages, changes Java
alternatives, writes user configuration, or contacts a network service.
"""
from __future__ import annotations

import argparse
import json
import pathlib
import re
import shutil
import subprocess
from typing import Any

DEFAULT_ROOT = pathlib.Path("/etc/sasd/toolchains.d")


def read_markers(root: pathlib.Path) -> dict[str, dict[str, str]]:
    """Read simple key=value expectation files managed by Puppet."""
    result: dict[str, dict[str, str]] = {}
    if not root.is_dir():
        return result

    for path in sorted(root.glob("*.conf")):
        values: dict[str, str] = {}
        for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, value = line.split("=", 1)
            values[key] = value
        if values.get("sdk"):
            result[values["sdk"]] = values
    return result


def command_version(command: str, arguments: list[str]) -> dict[str, Any]:
    """Run a version command with a short timeout and return compact evidence."""
    path = shutil.which(command)
    if not path:
        return {"present": False, "path": None, "version": None}

    try:
        process = subprocess.run(
            [path, *arguments],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            timeout=15,
            check=False,
        )
    except subprocess.TimeoutExpired:
        return {
            "present": False,
            "path": path,
            "version": None,
            "error": "version command timed out",
        }

    first_line = next(
        (line.strip() for line in process.stdout.splitlines() if line.strip()),
        "",
    )
    return {
        "present": process.returncode == 0,
        "path": path,
        "version": first_line,
        "returncode": process.returncode,
    }


def java_major(version_line: str | None) -> int | None:
    """Extract a Java feature release from common java/javac version formats."""
    if not version_line:
        return None
    quoted = re.search(r'\"(?:1\.)?(\d+)', version_line)
    if quoted:
        return int(quoted.group(1))
    plain = re.search(r"\b(?:javac\s+)?(?:1\.)?(\d+)(?:[._+\-]|\b)", version_line)
    return int(plain.group(1)) if plain else None


def evaluate_policy(
    markers: dict[str, dict[str, str]], checks: dict[str, dict[str, Any]]
) -> list[str]:
    """Return policy violations that are stronger than command presence checks."""
    violations: list[str] = []
    java_marker = markers.get("java")
    if java_marker:
        expected_text = java_marker.get("expected_java_major")
        try:
            expected = int(expected_text) if expected_text else None
        except ValueError:
            violations.append("invalid expected_java_major marker")
            expected = None

        if expected is not None:
            for command in ("java", "javac"):
                result = checks.get(command, {})
                if not result.get("present"):
                    continue
                observed = java_major(result.get("version"))
                if observed is None:
                    violations.append(f"unable to determine {command} major version")
                elif observed != expected:
                    violations.append(
                        f"{command} major {observed} does not match expected {expected}"
                    )
    dotnet_marker = markers.get("dotnet")
    if dotnet_marker:
        expected_text = dotnet_marker.get("expected_dotnet_major")
        try:
            expected = int(expected_text) if expected_text else None
        except ValueError:
            violations.append("invalid expected_dotnet_major marker")
            expected = None
        result = checks.get("dotnet", {})
        if expected is not None and result.get("present"):
            match = re.match(r"^(\d+)(?:\.|$)", result.get("version") or "")
            if not match:
                violations.append("unable to determine dotnet major version")
            elif int(match.group(1)) != expected:
                violations.append(
                    f"dotnet major {match.group(1)} does not match expected {expected}"
                )
    return violations


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--root", default=str(DEFAULT_ROOT))
    arguments = parser.parse_args()

    markers = read_markers(pathlib.Path(arguments.root))
    checks: dict[str, dict[str, Any]] = {}

    if "java" in markers:
        checks["java"] = command_version("java", ["-version"])
        checks["javac"] = command_version("javac", ["-version"])
        checks["maven"] = command_version("mvn", ["-version"])

    if "dotnet" in markers:
        checks["dotnet"] = command_version("dotnet", ["--version"])

    if "php" in markers:
        checks["php"] = command_version("php", ["--version"])
        if markers["php"].get("composer_expected") == "true":
            checks["composer"] = command_version("composer", ["--version"])

    missing = sorted(name for name, value in checks.items() if not value["present"])
    violations = evaluate_policy(markers, checks)
    status = "pass" if not missing and not violations else "fail"
    payload = {
        "schema_version": 1,
        "markers": markers,
        "commands": checks,
        "status": status,
        "missing": missing,
        "policy_violations": violations,
    }

    if arguments.json:
        print(json.dumps(payload, indent=2, sort_keys=True))
    else:
        for name, value in sorted(checks.items()):
            state = "OK" if value["present"] else "MISSING"
            print(f"{name:10} {state:8} {value.get('version') or ''}")
        for violation in violations:
            print(f"policy: {violation}")
        print(f"status={status}")

    return 0 if status == "pass" else 3


if __name__ == "__main__":
    raise SystemExit(main())
