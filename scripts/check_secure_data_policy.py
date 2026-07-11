#!/usr/bin/env python3
"""Validate the active Hiera-eyaml and concrete credential-consumer contract."""
from __future__ import annotations

import json
import pathlib
import re
import sys
import yaml

ROOT = pathlib.Path(__file__).resolve().parents[1]
errors: list[str] = []
version = (ROOT / 'VERSION').read_text().strip()
policy = json.loads((ROOT / 'config/secure-data-policy.json').read_text())
if policy.get('version') != version:
    errors.append('secure-data policy version differs from VERSION')
if policy.get('backend', {}).get('version') != '5.0.1':
    errors.append('hiera-eyaml version must remain pinned to 5.0.1')

hiera = yaml.safe_load((ROOT / 'hiera.yaml').read_text())
levels = hiera.get('hierarchy', [])
eyaml = next((level for level in levels if level.get('lookup_key') == 'eyaml_lookup_key'), None)
if not eyaml:
    errors.append('active hiera.yaml lacks eyaml_lookup_key level')
else:
    if eyaml.get('path') != policy['hierarchy']['path']:
        errors.append('encrypted hierarchy path differs from policy')
    options = eyaml.get('options', {})
    expected = {
        'pkcs7_private_key': policy['hierarchy']['private_key'],
        'pkcs7_public_key': policy['hierarchy']['public_key'],
    }
    for key, value in expected.items():
        if options.get(key) != value:
            errors.append(f'{key} differs from policy')
    if options.get('cache_decrypted') is not False:
        errors.append('cache_decrypted must be false')

common = yaml.safe_load((ROOT / 'data/common.yaml').read_text())
lookup = common.get('lookup_options', {}).get('profile::apt_repository_credentials::password', {})
if lookup.get('convert_to') != 'Sensitive':
    errors.append('password lookup must convert_to Sensitive')

secret_root = ROOT / 'secrets/nodes'
for path in secret_root.glob('*'):
    if path.name == 'README.md':
        continue
    if path.suffix != '.eyaml':
        errors.append(f'unexpected file in secrets/nodes: {path.name}')

for path in (ROOT / 'data/nodes').glob('*.yaml'):
    text = path.read_text()
    if re.search(r'(?m)^profile::apt_repository_credentials::password\s*:', text):
        errors.append(f'plaintext node data contains password key: {path.name}')

if errors:
    print('\n'.join('ERROR: ' + error for error in errors), file=sys.stderr)
    raise SystemExit(1)
print('Secure-data policy passed: active per-node eyaml, Sensitive conversion, fixed consumer, and no plaintext node password.')
