# puppet-software-baseline

[Deutsche Dokumentation](README.de.md) · [English documentation index](docs/en/README.md)

Puppet control repository for installing applications and maintaining consistent package, service, and configuration baselines across SASD systems.

> **Status:** Milestone 1 complete (`0.1.0`). The repository is fully structured, documented, validated, and catalog-compilable, but intentionally contains no productive application workload.

## Purpose

This project describes persistent desired state. It will install approved applications, keep configuration files and services consistent, and provide reproducible catalogs through a future Puppet Server and r10k deployment.

It is not an incident-response or troubleshooting repository. Diagnostics, temporary repairs, one-time operational procedures, and ad-hoc remediation belong in the SASD Ansible and administration tool repositories.

## Milestone 1 safety guarantee

The current catalog follows a real classification chain:

```text
node default -> role::baseline -> profile::baseline -> no workload resources
```

It declares no package, file, service, user, group, repository, mount, schedule, or `exec` resource. The local runner also defaults to `--noop`. Milestone 1 can therefore verify the engineering foundation without installing or reconfiguring applications.

## What Milestone 1 delivers

- Puppet 8 control-repository layout;
- Hiera 5 hierarchy;
- roles-and-profiles boundary;
- default workload-free catalog;
- Puppet Server/r10k-ready `environment.conf` and `Puppetfile`;
- catalog `config_version` with Git and VERSION fallback;
- validation of Puppet, YAML, JSON, metadata, shell, and structure;
- RSpec-Puppet unit tests;
- isolated local no-op catalog test;
- GitHub Actions validation;
- detailed English and German documentation;
- architecture decision records.

Read the complete [Milestone 1 specification](docs/en/milestone-1.md).

## Repository layout

```text
puppet-software-baseline/
├── .github/                 CI, Dependabot, issue and PR templates
├── data/                    Hiera environment data
├── docs/                    English, German, and ADR documentation
├── manifests/site.pp        Classification entry point
├── modules/                 r10k-generated dependencies; not committed
├── scripts/                 Validation, no-op apply, config version
├── site-modules/
│   ├── profile/             Technical implementation profiles
│   └── role/                Node-purpose compositions
├── tests/                   Smoke tests and fact fixtures
├── environment.conf
├── hiera.yaml
├── Puppetfile
├── Gemfile
├── Rakefile
└── VERSION
```

## Development quick start

Requirements: Ruby 3.2/3.3, Bundler, Git, Python 3, ShellCheck, yamllint, and build tools required by the Puppet gem. The development suite pins the publicly available Puppet 8.10.0 Ruby gem.

```bash
git clone https://github.com/SASD-Sysadmin/puppet-software-baseline.git
cd puppet-software-baseline
gem install bundler
./scripts/setup-development.sh
bundle exec rake
```

The complete verification command is the same locally and in CI:

```bash
bundle exec rake
```

Individual checks:

```bash
bundle exec rake validate
bundle exec rake spec
bundle exec rake catalog
```

## Local Puppet execution

```bash
./scripts/apply-local.sh          # no-op by default
./scripts/apply-local.sh --noop
./scripts/apply-local.sh --apply  # explicit enforcement only
```

`--apply` is harmless in Milestone 1 because the catalog has no workload, but later stepstones will make it operationally significant.

## Future Puppet Server model

```text
GitHub control repository
          |
          | r10k / Code Manager
          v
     Puppet Server
          |
          | authenticated compiled catalogs
          v
      Puppet Agents
```

Agents will not clone this repository. The server will deploy code, compile catalogs, and serve them over authenticated TLS. See [Puppet Server readiness](docs/en/server-readiness.md).

## Engineering rules

- roles compose profiles;
- profiles implement coherent technical capabilities;
- `site.pp` classifies but does not implement applications;
- external modules are pinned in `Puppetfile`;
- `modules/` is generated and never maintained manually;
- data belongs in Hiera;
- node-specific exceptions remain exceptional;
- no secrets in Git;
- productive changes require tests, documentation, and reviewed no-op output.

## Documentation

English is the leading language. German documentation is maintained as an additional operational reference.

- [English documentation](docs/en/README.md)
- [Deutsche Dokumentation](docs/de/README.md)
- [Architecture decisions](docs/adr/)
- [Contributing](CONTRIBUTING.md)
- [Security policy](SECURITY.md)
- [Changelog](CHANGELOG.md)

## License

Licensed under the [MIT License](LICENSE).
