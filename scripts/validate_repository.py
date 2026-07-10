#!/usr/bin/env python3
"""Check the Milestone 10 structural, SDK, repository-trust, platform, lifecycle, and security contract."""
from __future__ import annotations
import json,pathlib,sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
REQUIRED=(
 'README.md','README.de.md','LICENSE','VERSION','Puppetfile','environment.conf','hiera.yaml','manifests/site.pp',
 'config/role-catalog.json','config/node-data-contract.json','config/platform-catalog.json','config/operations-policy.json','config/sdk-catalog.json','config/dotnet-repository-catalog.json','config/hiera-eyaml.yaml.example',
 'data/common.yaml','data/nodes/README.md','data/retired/README.md','secrets/README.md','secrets/.gitignore',
 'site-modules/profile/metadata.json','site-modules/profile/manifests/sdk_status.pp','site-modules/profile/manifests/java_sdk.pp','site-modules/profile/manifests/php_sdk.pp','site-modules/profile/manifests/dotnet_sdk.pp','site-modules/profile/templates/dotnet.conf.epp','site-modules/profile/files/sasd-sdk-status.py','site-modules/profile/manifests/systemd_reload.pp','site-modules/profile/manifests/monitoring_bridge.pp','site-modules/profile/manifests/lifecycle_state.pp','site-modules/profile/templates/lifecycle.conf.epp','site-modules/profile/manifests/platform_state.pp','site-modules/profile/templates/platform.conf.epp',
 'site-modules/profile/manifests/agent_service.pp','site-modules/role/manifests/dotnet_development.pp','site-modules/role/metadata.json','site-modules/sasd_reporting/metadata.json',
 'scripts/manage-node.rb','scripts/check_node_data.rb','scripts/node-inventory.rb','scripts/fleet-compliance.rb','scripts/decommission-node.sh',
 'scripts/check_sdk_catalog.py','scripts/check_milestone9_scope.py','scripts/check_milestone10_scope.py','scripts/check_dotnet_repository_catalog.py','scripts/setup-dotnet-repository.sh','scripts/setup-hiera-eyaml.sh','scripts/prepare-hiera-eyaml.sh','scripts/check_secret_policy.py','scripts/check_milestone6_scope.py','scripts/check_milestone7_scope.py','scripts/check_milestone8_scope.py','scripts/check_operations_policy.py','scripts/check_platform_catalog.py','scripts/write-puppet-core-yum-credentials.py','scripts/export-monitoring.py','scripts/generate-audit-bundle.sh','scripts/verify-audit-bundle.sh','scripts/recovery-readiness.py','scripts/rehearse-recovery.sh','scripts/upgrade-preflight.sh','scripts/generate-puppetdb-retention.py','scripts/deactivate-puppetdb-node.sh',
 'docs/en/milestone-10.md','docs/de/milestone-10.md','docs/en/milestone-10-runbook.md','docs/de/milestone-10-runbook.md','docs/en/dotnet-sdk.md','docs/de/dotnet-sdk.md','docs/en/dotnet-repository-trust.md','docs/de/dotnet-repository-trust.md','docs/en/milestone-9.md','docs/de/milestone-9.md','docs/en/milestone-9-runbook.md','docs/de/milestone-9-runbook.md','docs/en/java-sdk.md','docs/de/java-sdk.md','docs/en/php-sdk.md','docs/de/php-sdk.md','docs/en/sdk-status-and-validation.md','docs/de/sdk-status-and-validation.md','docs/en/milestone-6.md','docs/de/milestone-6.md','docs/en/node-lifecycle.md','docs/de/node-lifecycle.md',
 'docs/en/inventory-and-compliance.md','docs/de/inventory-and-compliance.md','docs/en/maintenance-windows.md','docs/de/maintenance-windows.md',
 'docs/en/decommissioning.md','docs/de/decommissioning.md','docs/en/secure-data-foundation.md','docs/de/secure-data-foundation.md',
 'docs/en/milestone-6-runbook.md','docs/de/milestone-6-runbook.md','docs/en/milestone-8.md','docs/de/milestone-8.md','docs/en/milestone-8-runbook.md','docs/de/milestone-8-runbook.md','docs/en/milestone-7.md','docs/de/milestone-7.md','docs/en/redhat-family-agents.md','docs/de/redhat-family-agents.md','docs/en/cross-platform-package-data.md','docs/de/cross-platform-package-data.md','docs/en/selinux-and-firewall-boundary.md','docs/de/selinux-and-firewall-boundary.md','docs/en/milestone-7-runbook.md','docs/de/milestone-7-runbook.md',
 '.github/workflows/dotnet-sdk.yml','tests/integration/dotnet-package-availability.sh','tests/smoke/sdk-profiles.sh','tests/smoke/sdk-status.sh','tests/smoke/dotnet-profile.sh','tests/smoke/dotnet-repository.sh','tests/smoke/monitoring-export.sh','tests/smoke/audit-bundle.sh','tests/smoke/recovery-rehearsal.sh','tests/smoke/upgrade-preflight.sh','tests/smoke/puppetdb-retention.sh','tests/smoke/node-lifecycle.sh','tests/smoke/inventory-compliance.sh','tests/smoke/secret-policy.sh','tests/smoke/decommission-guards.sh','tests/smoke/redhat-family.sh','tests/smoke/puppet-core-yum-credentials.sh',
)
EXECUTABLE=tuple(x for x in REQUIRED if x.startswith('scripts/') or x.startswith('tests/'))
def fail(msg): print(f'ERROR: {msg}',file=sys.stderr)
def main():
    failures=0
    for rel in REQUIRED:
        if not (ROOT/rel).is_file(): fail(f'missing required file: {rel}'); failures+=1
    version=(ROOT/'VERSION').read_text().strip()
    if version!='0.10.0': fail('VERSION must be 0.10.0 for Milestone 10'); failures+=1
    for rel in ('site-modules/profile/metadata.json','site-modules/role/metadata.json','site-modules/sasd_reporting/metadata.json'):
        try:
            d=json.loads((ROOT/rel).read_text())
            if d.get('version')!=version: fail(f'{rel}: version differs from VERSION'); failures+=1
            if not d.get('name','').startswith('sasd-'): fail(f'{rel}: module name must use sasd namespace'); failures+=1
        except Exception as exc: fail(f'{rel}: {exc}'); failures+=1
    for rel in ('config/role-catalog.json','config/node-data-contract.json','config/platform-catalog.json','config/operations-policy.json','config/sdk-catalog.json','config/dotnet-repository-catalog.json'):
        d=json.loads((ROOT/rel).read_text())
        if d.get('version')!=version: fail(f'{rel}: version differs from VERSION'); failures+=1
    common=(ROOT/'data/common.yaml').read_text()
    for token in ("sasd::role: baseline","sasd::lifecycle_state: active",f"profile::baseline::baseline_version: '{version}'"):
        if token not in common: fail(f'data/common.yaml missing {token}'); failures+=1
    site=(ROOT/'manifests/site.pp').read_text()
    for state in ('active','maintenance','retired'):
        if f"'{state}'" not in site: fail(f'site.pp missing lifecycle state {state}'); failures+=1
    if 'No catalog is compiled' not in site: fail('site.pp lacks explicit retired-node compilation stop'); failures+=1
    for rel in EXECUTABLE:
        p=ROOT/rel
        if p.exists() and not (p.stat().st_mode & 0o111): fail(f'required script not executable: {rel}'); failures+=1
    forbidden_suffix={'.pem','.key','.p12','.pfx','.jks','.keystore','.dump'}
    for p in ROOT.rglob('*'):
        if '.git' in p.parts or not p.is_file(): continue
        rel=str(p.relative_to(ROOT))
        if p.suffix.lower() in forbidden_suffix: fail(f'potential secret material: {rel}'); failures+=1
    if failures: print(f'Repository validation failed with {failures} error(s).',file=sys.stderr); return 1
    print('Milestone 10 repository structure validation passed.'); return 0
if __name__=='__main__': raise SystemExit(main())
