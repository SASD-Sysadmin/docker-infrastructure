# Security

## Milestone 4 controls

- no-op remains the default for standalone bootstrap/update and optional PuppetDB planning;
- applying catalogs and all CA-changing operations require explicit action;
- unsupported platforms fail before installation or enforcement;
- catalog resources are limited to package, file, service, and one exact refresh-only systemd daemon reload;
- no users, groups, firewall, mounts, cron, schedules, or arbitrary command execution;
- autosigning is disabled and certificate operations target one exact certname;
- a pre-existing CA is never regenerated, renamed, or silently assigned DNS names;
- agent services remain disabled until certificate approval and an explicit activation test;
- agent identity values are configured by enrollment scripts, not rewritten by manifests;
- `main -> test -> production` promotion is fast-forward only;
- production deployment remains manual and authenticated;
- compact reports exclude facts, logs, diffs, command output, and resource values;
- backups are mode `0600`, checksummed, private-key-bearing artifacts requiring encryption;
- PuppetDB is opt-in and blocked without Puppet Server 8+, packages, monitoring, and backup.

## Privileged-code review

Treat changes under `scripts/`, `manifests/`, `site-modules/`, `data/`,
`Puppetfile`, `.github/workflows/`, and `systemd/` as privileged. Review exact
diffs, run the complete suite, test on snapshot-backed systems, and retain no-op
and promotion evidence with the change record.

## Certificate identity

A Puppet certname is a durable machine identity. Verify DNS, hostname, asset
ownership, and the pending CSR before signing. Never copy another node's private
key or SSL directory. Use the documented revoke/clean/re-enrollment process for
rebuilds or renames.
