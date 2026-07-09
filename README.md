# puppet-software-baseline

[Deutsche Dokumentation](README.de.md)

> **Status:** Milestone 7 complete (`0.7.0`). Central agents now include AlmaLinux 9 and Rocky Linux 9, with reviewed OS-family package mappings and unchanged security boundaries.

A conservative Puppet control repository for installing reviewed applications and maintaining consistent package, file, service, lifecycle, and operational state across SASD systems. Puppet manifests describe durable state; operational scripts and runbooks cover enrollment, promotion, backup, recovery, and lifecycle actions.

## Supported platforms

| Platform | Central agent | Standalone local | Package source |
|---|---:|---:|---|
| Debian 12 | yes | yes | distribution or Puppet Core |
| Debian 13 | yes | yes | distribution or Puppet Core |
| Ubuntu 24.04 | yes | yes | distribution or Puppet Core |
| AlmaLinux 9 | yes | no | authenticated Puppet Core |
| Rocky Linux 9 | yes | no | authenticated Puppet Core |

Puppet Server remains supported on Debian 12 and Ubuntu 24.04 only.

## Milestone 7 highlights

- complete Debian-family and RedHat-family package maps in Hiera;
- EL9 central-agent bootstrap with protected Puppet Core credentials;
- fixed allowlisted roles and reviewed node lifecycle;
- local platform evidence under `/etc/sasd/platform.d/current.conf`;
- package, platform, role, lifecycle, secret, promotion, backup, and release policy gates;
- CI package-availability tests on Rocky Linux 9 and AlmaLinux 9;
- no EPEL, firewall, SELinux, arbitrary repair commands, or automatic production deployment.

## First commands

```bash
./scripts/validate.sh
ruby scripts/node-inventory.rb
python3 scripts/check_platform_catalog.py
```

EL9 enrollment starts with a dry run:

```bash
sudo ./scripts/bootstrap-central-agent.sh   --server puppet.example.test   --certname rocky01.example.test   --package-source puppet-core   --api-key-file /root/puppet-core-api-key   --dry-run
```

## Documentation

- [Milestone 7](docs/en/milestone-7.md)
- [EL9 agent enrollment](docs/en/redhat-family-agents.md)
- [Cross-platform package data](docs/en/cross-platform-package-data.md)
- [SELinux and firewall boundary](docs/en/selinux-and-firewall-boundary.md)
- [Milestone 7 runbook](docs/en/milestone-7-runbook.md)
- [Architecture](docs/en/architecture.md)
- [Security](docs/en/security.md)
- [Roadmap](docs/en/roadmap.md)

## License

MIT — see [LICENSE](LICENSE).
