# puppet-software-baseline

[Deutsche Dokumentation](README.de.md) · [English documentation index](docs/en/README.md)

Puppet control repository for installing reviewed application groups and maintaining consistent package, service, configuration, reporting, and control-plane baselines across SASD systems.

> **Status:** Milestone 5 complete (`0.5.0`). The repository now provides explicit server, development, container-host, managed-agent, and Puppet-Server roles; tested application package profiles; machine-readable policy checks; and release-assurance tooling.

## Scope

Puppet declares persistent desired state. It does not replace Ansible runbooks, the Linux admin toolkit, incident response, or one-time repairs. Milestone 5 adds applications only through reviewed distribution packages:

- minimal baseline packages;
- administration tools;
- command-line development tools;
- daemonless Podman/OCI tooling;
- native Puppet agent service consistency;
- Puppet Server health/reporting operations;
- controlled `main -> test -> production` promotion;
- release manifests, readiness gates, backups, and rollback preparation.

No role adds third-party repositories, pulls container images, creates users, opens firewall ports, stores secrets, or runs general shell commands.

## Role catalog

| Role | Purpose | Application groups |
|---|---|---|
| `baseline` | Standalone/local bootstrap baseline | baseline |
| `managed_agent` | Minimal centrally managed node | baseline |
| `server` | General-purpose server | baseline, administration |
| `development` | CLI development host | baseline, administration, development |
| `container_host` | Daemonless OCI host | baseline, administration, container tools |
| `puppet_server` | Puppet control plane | baseline, administration, server operations |

Classification stays allowlisted in [`manifests/site.pp`](manifests/site.pp). The same contract is represented in [`config/role-catalog.json`](config/role-catalog.json) and validated automatically.

## Application profiles

```text
profile::baseline
profile::administration_tools
profile::development_tools
profile::container_tools
profile::application_state
profile::agent_service
profile::server_operations
```

Package arrays are in [`data/common.yaml`](data/common.yaml), use Hiera `unique` merge, contain no duplicates between groups, and use only package names—not unreviewed version expressions.

Example node classification:

```yaml
---
sasd::role: development
```

Save it as `data/nodes/<trusted-certname>.yaml`, promote through `main`, `test`, and `production`, deploy with r10k, then run the agent in no-op before applying.

## Quality and release gates

```bash
ruby scripts/check_package_policy.rb
python3 scripts/check_role_catalog.py
./scripts/release-readiness.sh --require-branch main
python3 scripts/generate-release-manifest.py
python3 scripts/verify-release-manifest.py dist/release-manifest.json
```

Complete developer validation:

```bash
gem install bundler
./scripts/setup-development.sh
bundle exec rake
```

GitHub Actions validate Puppet 7.23 and Puppet 8 compatibility, RSpec-Puppet catalogs, Puppet/EPP syntax, shell/YAML/JSON/Ruby, package and role policy, release manifests, smoke tests, and disposable-container idempotence.

## Operational flow

```text
feature branch -> main -> test -> production -> r10k -> Puppet Server -> signed agents
```

Promotion remains fast-forward only. Production rollback creates a new reviewed descendant commit; it never force-pushes history or removes the CA.

## Documentation

- [Milestone 5 specification](docs/en/milestone-5.md)
- [Application profiles](docs/en/application-profiles.md)
- [Role catalog](docs/en/role-catalog.md)
- [Compliance and drift](docs/en/compliance-and-drift.md)
- [Release assurance](docs/en/release-assurance.md)
- [Production readiness](docs/en/production-readiness.md)
- [Milestone 5 runbook](docs/en/milestone-5-runbook.md)
- [German documentation](docs/de/README.md)

## License

Licensed under the [MIT License](LICENSE).
