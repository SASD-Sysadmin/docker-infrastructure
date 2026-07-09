# puppet-software-baseline

[Deutsche Dokumentation](README.de.md) · [English documentation index](docs/en/README.md)

Puppet control repository for installing applications and maintaining consistent package, service, and configuration baselines across SASD systems.

> **Status:** Milestone 2 complete (`0.2.0`). The repository now provides a safe standalone local test operation and a first deliberately small package/file baseline for Debian 12, Debian 13, and Ubuntu 24.04 LTS.

## Purpose and boundary

This repository describes persistent desired state. It is not an incident-response, troubleshooting, or ad-hoc repair repository. Roles compose profiles; profiles own technical resources; data belongs in Hiera.

Milestone 2 deliberately allows only two workload resource types:

- `package` for a conservative administration tool set;
- `file` for `/etc/sasd` and a managed baseline marker.

Services, users, repositories, firewalls, mounts, schedules, and arbitrary commands remain out of scope.

## Delivered baseline

The default classification is:

```text
node default -> role::baseline -> profile::baseline
                                      |-> package baseline
                                      `-> /etc/sasd/puppet-baseline.conf
```

Packages are merged from Hiera and currently include `ca-certificates`, `curl`, `git`, `jq`, `rsync`, `tree`, `unzip`, `lsof`, and `procps`, plus narrow OS-specific additions.

## Supported local-test platforms

| Platform | Distribution Puppet package |
|---|---:|
| Debian 12 | Puppet 7.23 series |
| Debian 13 | Puppet 8.10 series |
| Ubuntu 24.04 LTS | Puppet 8.4 series |

The module metadata and CI cover Puppet `>= 7.23.0 < 9.0.0`.

## Safe bootstrap

On a fresh supported VM:

```bash
sudo ./scripts/bootstrap-agent.sh --noop
```

The script installs `ca-certificates`, `curl`, Git, the distribution `puppet-agent`, and r10k; clones or fast-forwards the repository under `/opt/sasd`; disables periodic server-oriented agent services; validates the clone; and performs a no-op run.

Only an explicit option enforces the baseline:

```bash
sudo ./scripts/bootstrap-agent.sh --apply
```

Review [bootstrap documentation](docs/en/bootstrap.md) before using `--apply`.

## Existing clone

```bash
./scripts/apply-local.sh --noop
sudo ./scripts/apply-local.sh --apply
./scripts/status-local.sh
sudo ./scripts/update-local.sh          # update and no-op
sudo ./scripts/update-local.sh --apply  # update and enforce
```

`apply-local.sh` defaults to no-op, rejects concurrent execution where `flock` is available, and requires root for real enforcement.

## Development and tests

```bash
gem install bundler
./scripts/setup-development.sh
bundle exec rake
```

CI validates both Puppet 7.23 and Puppet 8.10. A separate integration workflow applies the baseline twice inside disposable Debian 12, Debian 13, and Ubuntu 24.04 containers to verify enforcement and idempotence.

## Puppet Server future

Milestone 2 remains standalone. The control-repository layout, trusted-certname Hiera path, roles/profiles, `Puppetfile`, and `environment.conf` remain ready for a later Puppet Server and r10k deployment. Agents will then receive compiled catalogs instead of cloning this repository.

## Documentation

- [Milestone 2 specification](docs/en/milestone-2.md)
- [Bootstrap](docs/en/bootstrap.md)
- [Local operation](docs/en/local-operation.md)
- [Baseline definition](docs/en/baseline.md)
- [Supported platforms](docs/en/supported-platforms.md)
- [Rollback](docs/en/rollback.md)
- [Validation](docs/en/validation.md)
- [German documentation](docs/de/README.md)
- [Architecture decisions](docs/adr/)

## License

Licensed under the [MIT License](LICENSE).
