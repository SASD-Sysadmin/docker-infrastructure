#!/usr/bin/env python3
"""Enforce Milestone 11 Hiera-eyaml and APT credential boundaries."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
errors: list[str] = []
profile = (ROOT / 'site-modules/profile/manifests/apt_repository_credentials.pp').read_text()
template = (ROOT / 'site-modules/profile/templates/apt-auth.conf.epp').read_text()
role = (ROOT / 'site-modules/role/manifests/apt_repository_client.pp').read_text()
combined = (profile + '\n' + role).lower()

for resource_type in ('package', 'service', 'exec', 'user', 'group', 'cron', 'mount', 'host', 'schedule'):
    if re.search(rf'\b{resource_type}\s*\{{', combined):
        errors.append(f'credential scope declares forbidden {resource_type} resource')

for marker in ('apt-key', 'signed-by', 'deb http', 'deb https', 'sources.list', 'curl | sh', 'wget | sh'):
    if marker in combined:
        errors.append(f'credential scope must not configure repository trust/source: {marker}')

for required in (
    'Sensitive[String[1]] $password',
    "'/etc/apt/auth.conf.d/sasd-private-repository.conf'",
    'show_diff => false',
    "$trusted['authenticated'] == 'remote'",
    "$facts['os']['family'] == 'Debian'",
):
    if required not in profile:
        errors.append(f'credential profile lacks safeguard: {required}')

if 'Sensitive[String] $password' not in template or '<%= $password %>' not in template:
    errors.append('EPP template must preserve Sensitive interpolation')
if 'apt_repository_client' not in role or 'Debian OS family' not in role:
    errors.append('role lacks explicit Debian-only boundary')
for forbidden in ('private_key', 'ssh key', 'ca key', 'signing key'):
    if forbidden in template.lower():
        errors.append(f'template must not consume high-value secret: {forbidden}')

if errors:
    print('\n'.join('ERROR: ' + error for error in errors), file=sys.stderr)
    raise SystemExit(1)
print('Milestone 11 boundary passed: one Debian APT auth file, Sensitive content, no repository source/trust automation, no high-value keys.')
