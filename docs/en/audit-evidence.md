# Audit evidence

`generate-audit-bundle.sh` creates a mode-0600 archive containing the reviewed contracts, Git version, node inventory, compact compliance, health state, optional public certificate inventory, component versions, and an internal SHA-256 manifest. It intentionally excludes private keys, API keys, eyaml plaintext, full reports, and backup data.

```bash
sudo ./scripts/generate-audit-bundle.sh --output-directory /srv/audit/puppet
./scripts/verify-audit-bundle.sh /srv/audit/puppet/sasd-puppet-audit-*.tar.gz
```

The bundle is operational evidence, not a cryptographic author signature.
