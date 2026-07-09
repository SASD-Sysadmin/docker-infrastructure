#!/usr/bin/env python3
"""Check the structural contract of the SASD Puppet control repository."""
from __future__ import annotations
import json, pathlib, sys
ROOT = pathlib.Path(__file__).resolve().parents[1]
REQUIRED = (
    'README.md','README.de.md','LICENSE','VERSION','Puppetfile','environment.conf','hiera.yaml',
    'manifests/site.pp','site-modules/profile/metadata.json',
    'site-modules/profile/manifests/baseline.pp','site-modules/profile/templates/baseline.conf.epp',
    'site-modules/role/metadata.json','site-modules/role/manifests/baseline.pp',
    'scripts/bootstrap-agent.sh','scripts/apply-local.sh','scripts/update-local.sh',
    'scripts/status-local.sh','scripts/install-module-dependencies.sh','scripts/lib/common.sh',
    'scripts/render_fixture_facts.rb',
    'scripts/check_milestone2_scope.py','spec/spec_helper.rb',
    'docs/en/milestone-2.md','docs/de/milestone-2.md',
)

def fail(message): print(f'ERROR: {message}', file=sys.stderr)

def main():
    failures=0
    for relative in REQUIRED:
        if not (ROOT/relative).is_file(): fail(f'missing required file: {relative}'); failures+=1
    version=(ROOT/'VERSION').read_text().strip()
    for relative in ('site-modules/profile/metadata.json','site-modules/role/metadata.json'):
        try:
            data=json.loads((ROOT/relative).read_text())
            if data.get('version') != version: fail(f'{relative}: version differs from VERSION'); failures+=1
            if not data.get('name','').startswith('sasd-'): fail(f'{relative}: module name must use sasd namespace'); failures+=1
        except Exception as exc: fail(f'{relative}: {exc}'); failures+=1
    common_data = (ROOT / 'data/common.yaml').read_text(encoding='utf-8')
    if f"profile::baseline::baseline_version: '{version}'" not in common_data:
        fail('data/common.yaml baseline_version must match VERSION')
        failures += 1
    for relative in ('scripts/bootstrap-agent.sh', 'scripts/apply-local.sh', 'scripts/update-local.sh',
                     'scripts/status-local.sh', 'scripts/install-module-dependencies.sh'):
        if (ROOT / relative).exists() and not ((ROOT / relative).stat().st_mode & 0o111):
            fail(f'required script is not executable: {relative}')
            failures += 1
    site=(ROOT/'manifests/site.pp').read_text()
    if 'include role::baseline' not in site: fail('site.pp must classify default node with role::baseline'); failures+=1
    hiera=(ROOT/'hiera.yaml').read_text()
    for token in ('facts.os.name','facts.os.release.major','facts.os.family','trusted.certname'):
        if token not in hiera: fail(f'hiera.yaml missing hierarchy token: {token}'); failures+=1
    forbidden={'.pem','.key','.p12','.pfx','.jks'}
    for path in ROOT.rglob('*'):
        if '.git' in path.parts or not path.is_file(): continue
        if path.suffix.lower() in forbidden: fail(f'potential secret material: {path.relative_to(ROOT)}'); failures+=1
    if failures:
        print(f'Repository structure validation failed with {failures} error(s).', file=sys.stderr); return 1
    print('Repository structure validation passed.'); return 0
if __name__ == '__main__': raise SystemExit(main())
