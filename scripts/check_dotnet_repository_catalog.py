#!/usr/bin/env python3
"""Validate the .NET repository/source contract."""
from pathlib import Path
import json,sys
ROOT=Path(__file__).resolve().parents[1]; errors=[]
data=json.loads((ROOT/'config/dotnet-repository-catalog.json').read_text())
version=(ROOT/'VERSION').read_text().strip()
if data.get('version')!=version: errors.append('dotnet repository catalog version differs from VERSION')
if data.get('sdk_major')!=10 or data.get('support_end')!='2028-11-14': errors.append('.NET contract must use .NET 10 LTS through 2028-11-14')
expected={'Debian 12','Debian 13','Ubuntu 24.04','AlmaLinux 9','Rocky 9'}
if set(data.get('platforms',{}))!=expected: errors.append('dotnet platform set mismatch')
for name,meta in data.get('platforms',{}).items():
    strategy=meta.get('strategy')
    if name.startswith('Debian'):
        if strategy!='microsoft': errors.append(f'{name} must use Microsoft repository')
        url=meta.get('config_package_url','')
        if not url.startswith('https://packages.microsoft.com/config/debian/') or not url.endswith('/packages-microsoft-prod.deb'): errors.append(f'{name} repository URL is not allowlisted')
        if meta.get('expected_package')!='packages-microsoft-prod': errors.append(f'{name} package metadata expectation mismatch')
    elif strategy!='distribution': errors.append(f'{name} must use distribution repository')
security=data.get('security',{})
for key in ('https_only','apt_key_forbidden','curl_to_shell_forbidden','package_metadata_validation','repository_setup_is_separate_from_puppet_catalog','operator_checksum_supported'):
    if security.get(key) is not True: errors.append(f'security flag must be true: {key}')
if errors: print('\n'.join('ERROR: '+x for x in errors),file=sys.stderr); raise SystemExit(1)
print('Dotnet repository catalog passed: Debian uses reviewed Microsoft config packages; Ubuntu and EL9 use distribution feeds.')
