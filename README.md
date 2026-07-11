# puppet-software-baseline

[Deutsche Dokumentation](README.de.md)

> **Status:** Milestone 11 complete (`0.11.0`). Per-node Hiera-eyaml is active with one narrowly reviewed Debian APT credential consumer.

A conservative Puppet control repository for installing reviewed applications and maintaining consistent package, file, service, lifecycle, operational, and encrypted configuration state across SASD systems.

## Milestone 11 highlights

- active Hiera 5 `eyaml_lookup_key` hierarchy;
- pinned Hiera-eyaml 5.0.1 and external PKCS7 key custody;
- Debian-only `apt_repository_client` role;
- root-only fixed APT auth file with Sensitive EPP rendering;
- secret-policy, encryption, key-staging, recovery, RSpec, smoke, and CI tests;
- no repository-source automation, no signing keys, and no high-value secrets.

## First commands

```bash
./scripts/validate.sh
python3 scripts/check_secure_data_policy.py
sudo ./scripts/verify-hiera-eyaml.sh --mode server
```

## Documentation

- [Milestone 11](docs/en/milestone-11.md)
- [Milestone 11 runbook](docs/en/milestone-11-runbook.md)
- [Hiera-eyaml operations](docs/en/hiera-eyaml-operations.md)
- [APT repository credential](docs/en/apt-repository-credentials.md)
- [Secure-data recovery](docs/en/secure-data-recovery.md)
- [Architecture](docs/en/architecture.md)
- [Security](docs/en/security.md)
- [Roadmap](docs/en/roadmap.md)

## License

MIT — see [LICENSE](LICENSE).
