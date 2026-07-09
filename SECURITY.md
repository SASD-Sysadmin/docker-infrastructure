# Security policy

## Supported version

Milestone 5 (`0.5.x`) is the current supported repository line.

## Never commit

- private keys, CSRs, certificates, API keys, tokens, passwords;
- Hiera secret values or unencrypted credential files;
- Puppet CA directories or host SSL state;
- PuppetDB/PostgreSQL dumps;
- control-plane backup archives or extracted backup content;
- full Puppet reports, facts, logs, or file diffs from production nodes.

## Control-plane rules

- certificate autosigning remains disabled;
- certificate operations identify exactly one reviewed certname;
- `test` and `production` are fast-forward-only branches;
- production code must pass through the test branch;
- no unauthenticated deployment webhook is included;
- agent manifests do not rewrite TLS identity settings;
- PuppetDB is optional and must be monitored and backed up when enabled;
- backup archives are private-key material and require encryption plus independent storage.

## Report privacy

`sasd_json` intentionally records only aggregate status metadata. Changes that
add facts, logs, resource values, diffs, command output, or full serialization
must be rejected unless a separate security review approves the exact fields.

## Vulnerability reporting

Open a private security advisory in the GitHub repository when possible. Do not
include active secrets, private keys, personal data, or production reports in a
public issue. Revoke exposed credentials before discussing implementation details.
