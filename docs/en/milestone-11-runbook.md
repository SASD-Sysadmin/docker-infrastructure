# Milestone 11 runbook

1. Back up the Puppet control plane and verify the archive.
2. Install/verify `hiera-eyaml` 5.0.1 and the PKCS7 pair on every compiler.
3. Encrypt a replaceable read-only repository password with the public key.
4. Add normal node data and the matching `secrets/nodes/<certname>.eyaml`.
5. Run `scripts/validate.sh`, RSpec, and the isolated eyaml roundtrip.
6. Promote `main -> test`; compile the target node in no-op mode.
7. Confirm that reports redact the content and the target file is mode `0600`.
8. Promote `test -> production` and monitor the first agent run.
9. Remove the secret role before deleting or rotating the external account.
10. Keep compiler caches, backups, and private keys root-protected.
