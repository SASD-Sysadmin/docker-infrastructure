#!/usr/bin/env python3
"""Check the structural contract of the SASD Puppet control repository."""
from __future__ import annotations

import json
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
REQUIRED = (
    'README.md', 'README.de.md', 'LICENSE', 'VERSION', 'Puppetfile',
    'environment.conf', 'hiera.yaml', 'manifests/site.pp',
    'site-modules/profile/metadata.json',
    'site-modules/profile/manifests/baseline.pp',
    'site-modules/role/metadata.json',
    'site-modules/role/manifests/baseline.pp',
    'scripts/config_version.sh', 'scripts/apply-local.sh',
    'scripts/validate_yaml.rb', 'scripts/check_markdown_links.py',
    'scripts/check_no_workload.py', 'spec/spec_helper.rb',
    'docs/en/milestone-1.md', 'docs/de/milestone-1.md',
)


def fail(message: str) -> None:
    print(f'ERROR: {message}', file=sys.stderr)


def main() -> int:
    failures = 0
    for relative in REQUIRED:
        if not (ROOT / relative).is_file():
            fail(f'missing required file: {relative}')
            failures += 1

    version = (ROOT / 'VERSION').read_text(encoding='utf-8').strip()
    for relative in ('site-modules/profile/metadata.json', 'site-modules/role/metadata.json'):
        try:
            data = json.loads((ROOT / relative).read_text(encoding='utf-8'))
            if data.get('version') != version:
                fail(f'{relative}: version {data.get("version")!r} differs from VERSION {version!r}')
                failures += 1
            if not data.get('name', '').startswith('sasd-'):
                fail(f'{relative}: module name must use the sasd namespace')
                failures += 1
        except (OSError, json.JSONDecodeError) as exc:
            fail(f'{relative}: {exc}')
            failures += 1

    for relative in ('.github/ISSUE_TEMPLATE/bug_report.yml', '.github/ISSUE_TEMPLATE/feature_request.yml'):
        text = (ROOT / relative).read_text(encoding='utf-8')
        for required_key in ('name:', 'description:', 'body:'):
            if required_key not in text:
                fail(f'{relative}: missing issue-form key {required_key}')
                failures += 1

    site_manifest = (ROOT / 'manifests/site.pp').read_text(encoding='utf-8')
    if 'include role::baseline' not in site_manifest:
        fail('manifests/site.pp must classify the default node with role::baseline')
        failures += 1

    forbidden_extensions = {'.pem', '.key', '.p12', '.pfx', '.jks'}
    for path in ROOT.rglob('*'):
        if '.git' in path.parts or not path.is_file():
            continue
        if path.suffix.lower() in forbidden_extensions:
            fail(f'potential secret material is not allowed: {path.relative_to(ROOT)}')
            failures += 1

    if failures:
        print(f'Repository structure validation failed with {failures} error(s).', file=sys.stderr)
        return 1
    print('Repository structure validation passed.')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
