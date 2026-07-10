#!/usr/bin/env python3
"""Preserve Milestone 9 Java/PHP distribution-SDK boundaries."""
from pathlib import Path
import re,sys
ROOT=Path(__file__).resolve().parents[1]; errors=[]
paths=[ROOT/'site-modules/profile/manifests/java_sdk.pp',ROOT/'site-modules/profile/manifests/php_sdk.pp']
text='\n'.join(p.read_text(errors='ignore') for p in paths).lower()
for forbidden_marker in ('curl | sh','curl|sh','wget | sh','getcomposer.org/installer','sdkman','update-alternatives','alternatives --set','dnf module enable','dnf module install','apt-key','add-apt-repository'):
    if forbidden_marker in text: errors.append(f'forbidden Java/PHP bootstrap or system-selection marker: {forbidden_marker}')
for manifest in paths:
    if re.search(r'\b(service|exec|user|group|cron|mount)\s*\{',manifest.read_text()): errors.append(f'{manifest.name} declares a forbidden resource type')
for role in ('java_development','php_development','polyglot_development'):
    if not (ROOT/f'site-modules/role/manifests/{role}.pp').is_file(): errors.append(f'missing SDK role {role}')
if errors: print('\n'.join('ERROR: '+e for e in errors),file=sys.stderr); raise SystemExit(1)
print('Milestone 9 boundary passed: Java/PHP distribution packages and read-only status only; no upstream installers, module-stream changes, or services.')
