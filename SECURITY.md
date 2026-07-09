# Security policy

## Reporting

Do not disclose credentials, host inventories, internal addresses, logs, or
private infrastructure data in a public issue. Use a private channel agreed with
the repository owner.

## Repository rules

- Never commit passwords, API keys, private keys, certificates, tokens, or Hiera secrets.
- Pin external modules to reviewed versions or immutable Git references.
- Review every no-op report before `--apply`.
- Run initial enforcement in a disposable VM or after a tested snapshot.
- Treat bootstrap and update scripts as privileged code.
- Refuse dirty/non-fast-forward deployments rather than hiding local changes.
- Do not bypass the supported-platform checks with synthetic os-release data.

## Milestone 2 exposure

The active baseline installs standard-repository packages and owns one
non-secret file under `/etc/sasd`. It does not open ports, start services, create
users, add package repositories, or execute arbitrary commands. The bootstrap
disables periodic Puppet agent services because no server exists yet.
