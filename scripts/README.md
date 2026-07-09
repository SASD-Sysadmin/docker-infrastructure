# Scripts

## Bootstrap and enrollment

- `bootstrap-agent.sh`, `apply-local.sh`: standalone mode.
- `bootstrap-server.sh`: Puppet Server/CA/r10k bootstrap.
- `bootstrap-central-agent.sh`, `activate-central-agent.sh`: central enrollment.
- `configure-agent-service.sh`: run interval, splay, reports, and native service.

## Code operation

- `deploy-environment.sh`: deploy one matching branch/environment through r10k.
- `promote-environment.sh`: fast-forward `main -> test -> production`.
- `prepare-rollback.sh`: create a new rollback commit in a separate worktree.

## Certificates and reporting

- `list-certificates.sh`, `sign-certificate.sh`, `clean-certificate.sh`.
- `configure-reporting.sh`, `report-status.py`.
- `server-health.sh`, `status-server.sh`.

## Backup and optional PuppetDB

- `backup-control-plane.sh`, `verify-backup.sh`.
- `bootstrap-puppetdb.sh`, `status-puppetdb.sh`.

All destructive or identity-bearing actions require explicit options. Dry-run or
plan-only behavior is the default where practical.
