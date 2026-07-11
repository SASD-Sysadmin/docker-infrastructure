# Upgrade and maintenance preflight

`upgrade-preflight.sh` is read-only. It checks Puppet agent/server majors, preferred Java 17, free space, and backup age against `config/operations-policy.json`. A pass authorizes planning, not execution.

```bash
sudo ./scripts/upgrade-preflight.sh --backup-age 3600 --output /var/lib/sasd-puppet/upgrade-preflight.json
```

Use `main → test → production`, test catalog compilation, take and verify a backup, stop unrelated change, upgrade one component class at a time, run no-op and health checks, then resume agents. Puppet 7 remains accepted for specific distribution agents but is not the preferred basis for a new server.
