# Standalone bootstrap

## Recommended first use

Use a disposable VM snapshot. Download or clone the repository, inspect the
script, then run:

```bash
sudo ./scripts/bootstrap-agent.sh --noop
```

The default operation:

1. verifies Debian 12/13 or Ubuntu 24.04;
2. updates APT metadata;
3. installs CA certificates, curl, and Git;
4. enables Ubuntu Universe only when Puppet packages are unavailable;
5. installs distribution `puppet-agent` and r10k packages;
6. disables periodic server-oriented Puppet services;
7. clones or fast-forwards the repository under `/opt/sasd`;
8. installs pinned Puppetfile modules;
9. validates the repository;
10. executes a no-op catalog.

## Options

```text
--repository-url URL
--branch NAME
--destination DIR
--noop
--apply
--dry-run
--os-release-file FILE
```

`--os-release-file` exists for deterministic tests. Do not use a synthetic file
to bypass support policy on a real host.

## Package-source decision

Milestone 2 intentionally uses distribution packages. Puppet Core package
repositories require authenticated access, while this local lab must remain
reproducible without embedding credentials. The future server milestone will
re-evaluate package provenance, support lifetime, and licensing.

## Failure behaviour

The script refuses unsupported platforms, dirty destination clones, non-Git
destination content, non-fast-forward updates, and real execution without root.
It never deletes an existing directory to recover from an error.
