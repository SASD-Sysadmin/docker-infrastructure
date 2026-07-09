#!/usr/bin/env python3
"""Check the Milestone 3 structural and security contract."""
from __future__ import annotations
import json,pathlib,sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
REQUIRED=(
 'README.md','README.de.md','LICENSE','VERSION','Puppetfile','environment.conf','hiera.yaml','manifests/site.pp',
 'site-modules/profile/metadata.json','site-modules/profile/manifests/baseline.pp','site-modules/profile/templates/baseline.conf.epp',
 'site-modules/role/metadata.json','site-modules/role/manifests/baseline.pp',
 'scripts/bootstrap-server.sh','scripts/deploy-environment.sh','scripts/bootstrap-central-agent.sh','scripts/activate-central-agent.sh',
 'scripts/list-certificates.sh','scripts/sign-certificate.sh','scripts/clean-certificate.sh','scripts/status-server.sh',
 'scripts/bootstrap-agent.sh','scripts/apply-local.sh','scripts/lib/common.sh','scripts/lib/puppet_packages.sh',
 'scripts/check_milestone3_scope.py','spec/spec_helper.rb','docs/en/milestone-3.md','docs/de/milestone-3.md',
 'tests/smoke/server-dry-run.sh','tests/smoke/central-agent-dry-run.sh','tests/smoke/ca-argument-validation.sh',
 'systemd/sasd-puppet-deploy.service','systemd/README.md','examples/server/r10k.yaml.example',
)
EXECUTABLE=tuple(x for x in REQUIRED if x.startswith('scripts/') or x.startswith('tests/'))

def fail(msg): print(f'ERROR: {msg}',file=sys.stderr)
def main():
    failures=0
    for rel in REQUIRED:
        if not (ROOT/rel).is_file(): fail(f'missing required file: {rel}'); failures+=1
    version=(ROOT/'VERSION').read_text().strip()
    if version!='0.3.0': fail('VERSION must be 0.3.0 for Milestone 3'); failures+=1
    for rel in ('site-modules/profile/metadata.json','site-modules/role/metadata.json'):
        try:
            d=json.loads((ROOT/rel).read_text())
            if d.get('version')!=version: fail(f'{rel}: version differs from VERSION'); failures+=1
            if not d.get('name','').startswith('sasd-'): fail(f'{rel}: module name must use sasd namespace'); failures+=1
        except Exception as exc: fail(f'{rel}: {exc}'); failures+=1
    common=(ROOT/'data/common.yaml').read_text()
    for token in ("sasd::role: baseline",f"profile::baseline::baseline_version: '{version}'"):
        if token not in common: fail(f'data/common.yaml missing {token}'); failures+=1
    site=(ROOT/'manifests/site.pp').read_text()
    for token in ("lookup('sasd::role'","'baseline'","include role::baseline"):
        if token not in site: fail(f'site.pp missing classification token: {token}'); failures+=1
    for rel in EXECUTABLE:
        p=ROOT/rel
        if p.exists() and not (p.stat().st_mode & 0o111): fail(f'required script is not executable: {rel}'); failures+=1
    forbidden={'.pem','.key','.p12','.pfx','.jks','.keystore'}
    for p in ROOT.rglob('*'):
        if '.git' in p.parts or not p.is_file(): continue
        if p.suffix.lower() in forbidden: fail(f'potential secret material: {p.relative_to(ROOT)}'); failures+=1
    if failures: print(f'Repository validation failed with {failures} error(s).',file=sys.stderr); return 1
    print('Milestone 3 repository structure validation passed.'); return 0
if __name__=='__main__': raise SystemExit(main())
