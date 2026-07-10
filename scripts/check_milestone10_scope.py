#!/usr/bin/env python3
"""Enforce Milestone 10 .NET SDK and repository-trust boundaries."""
from pathlib import Path
import re,sys
ROOT=Path(__file__).resolve().parents[1]; errors=[]
manifest=(ROOT/'site-modules/profile/manifests/dotnet_sdk.pp').read_text().lower()
role=(ROOT/'site-modules/role/manifests/dotnet_development.pp').read_text().lower()
status=(ROOT/'site-modules/profile/files/sasd-sdk-status.py').read_text().lower()
setup=(ROOT/'scripts/setup-dotnet-repository.sh').read_text().lower()
for marker in ('dotnet workload install','dotnet tool install','dotnet-install.sh','global.json','nuget.config','curl | sh','curl|sh','wget | sh'):
    if marker in manifest+role+status: errors.append(f'forbidden .NET machine-baseline marker: {marker}')
if re.search(r'\b(service|exec|user|group|cron|mount)\s*\{',manifest): errors.append('dotnet_sdk declares a forbidden resource type')
for required in ("--proto '=https'",'dpkg-deb --field','packages-microsoft-prod','apt-cache show dotnet-sdk-10.0'):
    if required not in setup: errors.append(f'repository setup lacks required safeguard: {required}')
for forbidden in ('apt-key','add-apt-repository','dotnet-install','curl | sh','curl|sh'):
    if forbidden in setup: errors.append(f'forbidden repository setup mechanism: {forbidden}')
if 'x86_64/amd64 only' not in manifest or 'x86_64/amd64 only' not in setup: errors.append('x86_64-only boundary is not explicit')
if errors: print('\n'.join('ERROR: '+e for e in errors),file=sys.stderr); raise SystemExit(1)
print('Milestone 10 boundary passed: .NET 10 package installation only, reviewed feeds, x86_64 only, no workloads/tools/services/user configuration.')
