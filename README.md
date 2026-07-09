# puppet-software-baseline

[Deutsche Dokumentation](README.de.md) · [English documentation index](docs/en/README.md)

Puppet control repository for installing applications and maintaining consistent package, service, and configuration baselines across SASD systems.

> **Status:** Milestone 3 complete (`0.3.0`). The repository now supports a central open-source Puppet Server, manual certificate enrollment, r10k deployment, and the existing safe standalone mode.

## Scope

The repository describes persistent desired state. It is not an incident-response or ad-hoc repair toolkit. Roles compose profiles, profiles own technical resources, and environment/node data belongs in Hiera.

The application workload remains deliberately small in Milestone 3: packages and the `/etc/sasd/puppet-baseline.conf` marker. The new work is the **control plane** around that catalog:

- Puppet Server bootstrap on Debian 12 or Ubuntu 24.04;
- explicit `production` branch and `production` environment;
- r10k code deployment;
- certificate-authority operations with autosigning disabled;
- central-agent enrollment for Debian 12/13 and Ubuntu 24.04;
- migration path from local `puppet apply` to central management.

## Architecture

```text
GitHub control repository
  main        integration and pull requests
  production  approved release branch
       |
       | r10k deploy environment production --puppetfile
       v
Puppet Server + CA
       |
       | mutually authenticated HTTPS / compiled catalogs
       v
Puppet agents
```

The default catalog classification is data-driven but allowlisted:

```text
data/common.yaml: sasd::role = baseline
            -> manifests/site.pp allowlist
            -> role::baseline
            -> profile::baseline
```

## Server quick start

Read [Puppet Server installation](docs/en/puppet-server-installation.md) first. On a fresh supported server:

```bash
sudo ./scripts/bootstrap-server.sh \
  --server-name puppet.example.test \
  --dns-alt-names puppet
```

The default package source is the distribution repository. For current Puppet Core packages, use `--package-source puppet-core` and provide a root-only API-key file; secrets are never accepted as command-line values or committed to Git.

Status and code deployment:

```bash
sudo ./scripts/status-server.sh
sudo ./scripts/deploy-environment.sh --environment production --branch production
```

## Agent enrollment

On a supported agent:

```bash
sudo ./scripts/bootstrap-central-agent.sh \
  --server puppet.example.test \
  --certname node01.example.test
```

On the Puppet Server, inspect and sign exactly that request:

```bash
sudo ./scripts/list-certificates.sh
sudo ./scripts/sign-certificate.sh --certname node01.example.test
```

Back on the agent, retrieve the certificate, preview the catalog, and enable periodic runs:

```bash
sudo ./scripts/activate-central-agent.sh --noop --enable-service
```

Use `--apply` only after reviewing the no-op output.

## Standalone mode remains supported

```bash
sudo ./scripts/bootstrap-agent.sh --noop
./scripts/apply-local.sh --noop
sudo ./scripts/apply-local.sh --apply
```

The managed marker records `local-puppet-apply` or `puppet-server` according to trusted catalog authentication.

## Security defaults

- no certificate autosigning;
- no private keys, API keys, certificates, or keystores in Git;
- exact certname validation and explicit certificate cleanup confirmation;
- agent service disabled until signed and activated;
- existing CA preserved, never silently regenerated;
- production code deployed only from the `production` branch;
- Puppet Core credentials read from a root-only file;
- no webhook or unattended production deployment in Milestone 3.

## Validation

```bash
gem install bundler
./scripts/setup-development.sh
bundle exec rake
```

CI tests Puppet 7.23 and 8.10, validates all shell/YAML/JSON/Puppet sources, checks documentation links and secret extensions, compiles supported fixture catalogs, and exercises local/server/central-agent dry-runs.

## Documentation

- [Milestone 3 specification](docs/en/milestone-3.md)
- [Puppet Server installation](docs/en/puppet-server-installation.md)
- [r10k and environments](docs/en/r10k-deployment.md)
- [Agent enrollment](docs/en/central-agent-enrollment.md)
- [Certificate operations](docs/en/certificate-management.md)
- [Server operations](docs/en/server-operations.md)
- [Network and DNS requirements](docs/en/network-requirements.md)
- [Backup and restore](docs/en/server-backup-restore.md)
- [Migration from local mode](docs/en/migration-to-server.md)
- [Troubleshooting](docs/en/server-troubleshooting.md)
- [German documentation](docs/de/README.md)

## License

Licensed under the [MIT License](LICENSE).
