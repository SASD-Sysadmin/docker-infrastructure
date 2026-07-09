# SDK status and validation

Puppet writes expectation markers below `/etc/sasd/toolchains.d`. The read-only command `/usr/local/sbin/sasd-sdk-status` compares those markers with commands available on the host.

```bash
sudo sasd-sdk-status
sudo sasd-sdk-status --json
```

A missing expected command returns exit code `3`. The command does not query internet registries, inspect project source trees, or report package-lock contents.

Repository validation:

```bash
python3 scripts/check_sdk_catalog.py
python3 scripts/check_milestone9_scope.py
tests/smoke/sdk-profiles.sh
tests/smoke/sdk-status.sh
```
