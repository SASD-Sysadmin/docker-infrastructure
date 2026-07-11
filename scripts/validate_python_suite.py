#!/usr/bin/env python3
"""Compile Python sources and run repository policy checks in one process."""
from __future__ import annotations

import pathlib
import py_compile
import runpy
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
python_files = sorted(
    path
    for base in (ROOT / "scripts", ROOT / "tests")
    for path in base.rglob("*.py")
)
for path in python_files:
    py_compile.compile(str(path), doraise=True)
print(f"Python syntax validation passed for {len(python_files)} file(s).")

checks = [
    "validate_json.py",
    "validate_repository.py",
    "check_markdown_links.py",
    "check_milestone6_scope.py",
    "check_milestone7_scope.py",
    "check_milestone8_scope.py",
    "check_milestone9_scope.py",
    "check_milestone10_scope.py",
    "check_milestone11_scope.py",
    "check_secure_data_policy.py",
    "check_dotnet_repository_catalog.py",
    "check_sdk_catalog.py",
    "check_operations_policy.py",
    "check_platform_catalog.py",
    "check_role_catalog.py",
    "check_secret_policy.py",
]
for name in checks:
    path = ROOT / "scripts" / name
    previous_argv = sys.argv
    try:
        sys.argv = [str(path)]
        runpy.run_path(str(path), run_name="__main__")
    except SystemExit as exc:
        code = exc.code if isinstance(exc.code, int) else 1
        if code:
            raise SystemExit(f"{name} failed with exit code {code}") from exc
    finally:
        sys.argv = previous_argv
print(f"Python policy suite passed for {len(checks)} check(s).")
