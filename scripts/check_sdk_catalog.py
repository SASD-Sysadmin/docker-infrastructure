#!/usr/bin/env python3
"""Validate SDK catalog, package mappings, role parity, and safety flags."""
from __future__ import annotations
import json,pathlib,sys
ROOT=pathlib.Path(__file__).resolve().parents[1]; errors=[]
cat=json.loads((ROOT/'config/sdk-catalog.json').read_text()); version=(ROOT/'VERSION').read_text().strip()
if cat.get('version')!=version: errors.append('SDK catalog version differs from VERSION')
required={'java_sdk','php_sdk'}
if set(cat.get('profiles',{}))!=required: errors.append('SDK catalog must contain exactly java_sdk and php_sdk')
java=cat.get('profiles',{}).get('java_sdk',{}); php=cat.get('profiles',{}).get('php_sdk',{})
if java.get('java_major')!=17 or java.get('build_tool')!='maven': errors.append('Java contract must be OpenJDK 17 with Maven')
for name,meta in [('java_sdk',java),('php_sdk',php)]:
    if meta.get('external_repositories') is not False: errors.append(f'{name} must prohibit external repositories')
    if meta.get('starts_services') is not False: errors.append(f'{name} must not start services')
    if set(meta.get('supported_os_families',[]))!={'Debian','RedHat'}: errors.append(f'{name} family support mismatch')
if php.get('composer_os_families')!=['Debian']: errors.append('Composer must be Debian-family only')
if php.get('changes_module_streams') is not False or php.get('installs_web_server') is not False: errors.append('PHP profile must not change module streams or install a web server')
for family in ('Debian','RedHat'):
    text=(ROOT/f'data/os/family/{family}.yaml').read_text()
    for profile in required:
        if f'profile::{profile}::packages:' not in text: errors.append(f'{family} lacks {profile} package data')
roles=json.loads((ROOT/'config/role-catalog.json').read_text()).get('roles',{})
for role,needed in {'java_development':'java_sdk','php_development':'php_sdk','polyglot_development':'java_sdk'}.items():
    if role not in roles: errors.append(f'missing SDK role {role}')
    elif needed not in roles[role].get('profiles',[]): errors.append(f'{role} lacks {needed}')
if 'php_sdk' not in roles.get('polyglot_development',{}).get('profiles',[]): errors.append('polyglot_development lacks php_sdk')
if errors: print('\n'.join('ERROR: '+e for e in errors),file=sys.stderr); raise SystemExit(1)
print('SDK catalog passed: OpenJDK 17/Maven and distribution PHP policy are internally consistent.')
