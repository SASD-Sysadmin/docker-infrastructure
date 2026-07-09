# puppet-software-baseline

[Deutsche Dokumentation](README.de.md)

> **Status:** Milestone 8 complete (`0.8.0`). The first repository line now includes production assurance, aggregate monitoring export, audit evidence, isolated recovery rehearsal, and upgrade/PuppetDB policy checks.

A conservative Puppet control repository for installing reviewed applications and maintaining consistent package, file, service, lifecycle, and operational state across SASD systems. Puppet manifests describe durable state; operational scripts and runbooks cover enrollment, promotion, backup, recovery rehearsal, and lifecycle actions.

## Supported platforms

| Platform | Central agent | Standalone local | Package source |
|---|---:|---:|---|
| Debian 12 | yes | yes | distribution or Puppet Core |
| Debian 13 | yes | yes | distribution or Puppet Core |
| Ubuntu 24.04 | yes | yes | distribution or Puppet Core |
| AlmaLinux 9 | yes | no | authenticated Puppet Core |
| Rocky Linux 9 | yes | no | authenticated Puppet Core |

Puppet Server remains supported on Debian 12 and Ubuntu 24.04 only.

## Milestone 8 highlights

- aggregate Prometheus, JSON, and Nagios-compatible monitoring export without per-node metric labels;
- checksum-verifiable audit bundles that exclude private keys and secret values;
- backup metadata, readiness inspection, and an isolated recovery rehearsal;
- read-only upgrade preflight and reviewed PuppetDB retention/deactivation policy;
- complete Debian-family and RedHat-family package maps with fixed allowlisted roles;
- no EPEL, firewall, SELinux, arbitrary repair commands, live restore, or automatic production deployment.

## First commands

```bash
./scripts/validate.sh
ruby scripts/node-inventory.rb
python3 scripts/check_operations_policy.py
```

Generate operational evidence:

```bash
sudo ./scripts/generate-audit-bundle.sh --output-directory /srv/audit/puppet
python3 ./scripts/recovery-readiness.py /secure/puppet-control-plane-backup.tar.gz
```

## Documentation

- [Milestone 8](docs/en/milestone-8.md)
- [Milestone 8 runbook](docs/en/milestone-8-runbook.md)
- [Monitoring integration](docs/en/monitoring-integration.md)
- [Audit evidence](docs/en/audit-evidence.md)
- [Disaster recovery rehearsal](docs/en/disaster-recovery-rehearsal.md)
- [Upgrade and maintenance](docs/en/upgrade-maintenance.md)
- [PuppetDB retention](docs/en/puppetdb-retention.md)
- [Architecture](docs/en/architecture.md)
- [Security](docs/en/security.md)
- [Roadmap](docs/en/roadmap.md)

## License

MIT — see [LICENSE](LICENSE).
