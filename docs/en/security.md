# Security

## Milestone 2 controls

- no-op is the default for bootstrap, update, and direct local execution;
- `--apply` requires root;
- synthetic fact fixtures cannot be combined with `--apply`;
- unsupported platforms fail before enforcement;
- the active profile is limited to package and file resources;
- no ports, services, users, repositories, firewall state, or arbitrary commands are managed;
- dirty Git clones and non-fast-forward updates are rejected;
- periodic Puppet agent services are disabled in standalone mode;
- potential key and certificate file extensions are rejected by validation;
- no secrets belong in Hiera or Git.

## Privileged-code review

Treat every change under `scripts/`, `manifests/`, `site-modules/`, `data/`, and
`Puppetfile` as privileged. Review exact diffs, run the full suite, test in a
snapshot-backed VM, and retain no-op output with the change record.

## Package trust

Milestone 2 installs packages only from already configured distribution
repositories. It does not add third-party APT sources. The future production
server design must separately decide package provenance, support, and update
policy.
