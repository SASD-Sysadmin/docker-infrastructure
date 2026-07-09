# puppet-software-baseline

[Deutsche Dokumentation](README.de.md) · [English documentation index](docs/en/README.md)

Puppet control repository for installing applications and maintaining consistent package, service, configuration, and central-operation baselines across SASD systems.

> **Status:** Milestone 4 complete (`0.4.0`). Central operations now include controlled test/production promotion, regular agent service enforcement, compact reporting, health checks, verified backups, rollback preparation, and optional PuppetDB.

## Scope

Puppet describes persistent desired state. It is not an incident-response or ad-hoc repair runner. Roles compose profiles, profiles own technical resources, and environment/node data belongs in Hiera.

Milestone 4 manages a deliberately conservative baseline and the Puppet control plane:

- packages and `/etc/sasd/puppet-baseline.conf`;
- native Puppet agent service state after certificate enrollment;
- Puppet Server operational scripts, state directories, health service/timer;
- compact non-secret JSON report summaries;
- `main -> test -> production` promotion and r10k deployment;
- optional same-host PuppetDB for historical queries and reports.

## Architecture

```text
GitHub control repository
  main  ->  test  ->  production
                  | r10k
                  v
             Puppet Server + CA
              |           |
      catalogs/reports    optional PuppetDB/PostgreSQL
              |
              v
          Puppet agents
```

Allowlisted classification:

```text
sasd::role = baseline      -> role::baseline
sasd::role = managed_agent -> role::managed_agent
sasd::role = puppet_server -> role::puppet_server
```

## Quick operational path

Promote and deploy test:

```bash
./scripts/promote-environment.sh --from main --to test --full-validation
./scripts/promote-environment.sh --from main --to test --push
sudo ./scripts/deploy-environment.sh --environment test --branch test
```

Promote approved test code and deploy production:

```bash
./scripts/promote-environment.sh --from test --to production --full-validation
./scripts/promote-environment.sh --from test --to production --push
sudo ./scripts/deploy-environment.sh --environment production --branch production
```

Configure a signed agent's regular service:

```bash
sudo ./scripts/configure-agent-service.sh --runinterval 1h --splaylimit 15m
```

Enable compact server reports and inspect health:

```bash
sudo ./scripts/configure-reporting.sh
sudo ./scripts/server-health.sh
sudo ./scripts/report-status.py
```

Create and verify a sensitive control-plane backup:

```bash
sudo ./scripts/backup-control-plane.sh
sudo ./scripts/verify-backup.sh /var/backups/sasd-puppet/puppet-control-plane-*.tar.gz
```

Optional PuppetDB preflight and installation:

```bash
sudo ./scripts/bootstrap-puppetdb.sh --dry-run
sudo ./scripts/bootstrap-puppetdb.sh --apply
sudo ./scripts/status-puppetdb.sh
```

## Security defaults

- no certificate autosigning or bulk signing;
- no credentials, private keys, certificates, database dumps, or backups in Git;
- test and production history is fast-forward only;
- no unauthenticated webhook or unattended production deployment;
- agent identity settings are not rewritten by Puppet manifests;
- compact reports exclude facts, logs, diffs, and resource values;
- PuppetDB is opt-in and requires Puppet Server 8+, packages, monitoring, and backup;
- rollback is a new reviewed commit, never CA deletion or branch force-reset.

## Validation

```bash
gem install bundler
./scripts/setup-development.sh
bundle exec rake
```

CI validates Puppet 7.23 and 8.10 compatibility, shell/YAML/JSON/Ruby/Puppet syntax, metadata, internal links, catalog fixtures, roles/profiles, report processor behavior, dry-runs, promotion guards, health output, and backup verification.

## Documentation

- [Milestone 4 specification](docs/en/milestone-4.md)
- [Central operational model](docs/en/operational-model.md)
- [Environments and promotion](docs/en/environments-and-promotion.md)
- [Agent scheduling](docs/en/agent-scheduling.md)
- [Compact reporting](docs/en/reporting.md)
- [Health monitoring](docs/en/health-monitoring.md)
- [Optional PuppetDB](docs/en/puppetdb.md)
- [Backup operations](docs/en/backup-operations.md)
- [Rollback operations](docs/en/rollback-operations.md)
- [Implementation runbook](docs/en/milestone-4-runbook.md)
- [German documentation](docs/de/README.md)

## License

Licensed under the [MIT License](LICENSE).
