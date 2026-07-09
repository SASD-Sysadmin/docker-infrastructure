# Security architecture

## Current controls

- no productive workload in Milestone 1;
- no-op default for local execution;
- isolated temporary Puppet runtime directories;
- strict-variable catalog compilation;
- pinned development dependencies;
- no external Puppet modules yet;
- secret-like file extensions rejected by structural validation;
- read-only GitHub Actions permissions;
- validation before merge;
- Local Git revision, or a visible VERSION fallback, recorded through `config_version`.

## Secret policy

Never commit passwords, API tokens, private keys, certificate private material, recovery codes, or unencrypted sensitive Hiera values. Examples in documentation must use invalid domains and unmistakable placeholders.

## Future controls

Before production, define branch protection, signed or reviewed releases, r10k deploy credentials, Puppet CA procedures, encrypted Hiera with independent key management, server backups, audit retention, monitoring, and tested recovery.

## Reporting vulnerabilities

Follow [`../../SECURITY.md`](../../SECURITY.md). Do not place sensitive vulnerability details in a public issue.
