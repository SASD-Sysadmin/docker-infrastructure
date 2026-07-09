# puppet-software-baseline

[Deutsche Dokumentation](README.de.md)

> **Status:** Milestone 9 complete (`0.9.0`). Reviewed Java and PHP command-line SDK profiles now extend the existing cross-platform application baseline.

A conservative Puppet control repository for installing reviewed applications and maintaining consistent package, file, service, lifecycle, and operational state across SASD systems.

## Supported platforms

| Platform | Central agent | Standalone local | Package source |
|---|---:|---:|---|
| Debian 12 | yes | yes | distribution or Puppet Core |
| Debian 13 | yes | yes | distribution or Puppet Core |
| Ubuntu 24.04 | yes | yes | distribution or Puppet Core |
| AlmaLinux 9 | yes | no | authenticated Puppet Core |
| Rocky Linux 9 | yes | no | authenticated Puppet Core |

Puppet Server remains supported on Debian 12 and Ubuntu 24.04 only.

## Milestone 9 highlights

- OpenJDK 17 and Maven profile on every supported agent platform;
- command-line PHP SDK from distribution/AppStream repositories;
- Composer from Debian-family repositories only;
- explicit `java_development`, `php_development`, and `polyglot_development` roles;
- read-only `sasd-sdk-status` evidence command;
- no vendor bootstrap installers, EPEL, SDKMAN, .NET, web server, PHP-FPM, or automatic module-stream changes.

## First commands

```bash
./scripts/validate.sh
python3 scripts/check_sdk_catalog.py
ruby scripts/node-inventory.rb
```

## Documentation

- [Milestone 9](docs/en/milestone-9.md)
- [Milestone 9 runbook](docs/en/milestone-9-runbook.md)
- [Java SDK](docs/en/java-sdk.md)
- [PHP SDK](docs/en/php-sdk.md)
- [SDK status and validation](docs/en/sdk-status-and-validation.md)
- [Architecture](docs/en/architecture.md)
- [Security](docs/en/security.md)
- [Roadmap](docs/en/roadmap.md)

## License

MIT — see [LICENSE](LICENSE).
