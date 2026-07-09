# Security policy

## Supported version

Milestone 6 (`0.6.x`) is the current supported repository line.

## Never commit

- private keys, CSRs, certificates, API keys, tokens, passwords;
- plaintext Hiera secret values or unencrypted credential files; encrypted `.eyaml` values are allowed only after the reviewed opt-in procedure;
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
- backup archives and eyaml private keys are sensitive control-plane material and require encryption plus independent storage.
- maintenance records require a ticket and expiry; retired nodes receive no catalog.
- `scripts/check_secret_policy.py` is a gate, not a substitute for human review or dedicated secret scanning.

## Report privacy

`sasd_json` intentionally records only aggregate status metadata. Changes that
add facts, logs, resource values, diffs, command output, or full serialization
must be rejected unless a separate security review approves the exact fields.

## Vulnerability reporting

Open a private security advisory in the GitHub repository when possible. Do not
include active secrets, private keys, personal data, or production reports in a
public issue. Revoke exposed credentials before discussing implementation details.

## Puppet Core repository credentials

AlmaLinux 9 and Rocky Linux 9 agents require authenticated Puppet Core package
access. Supply the API key only through a root-owned file without group or world
permissions. The generated Yum repository file contains reusable credentials
and is forced to mode `0600`. Never commit either file, paste it into an issue,
or include it unredacted in a support bundle.
