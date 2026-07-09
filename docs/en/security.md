# Security

## Milestone 6 controls

- fixed role and lifecycle allowlists in `site.pp`;
- mutual-TLS identity and manual certificate signing;
- exact-certname confirmation for destructive CA operations;
- retired nodes receive no catalog;
- maintenance requires ticket, reason, and expiry;
- no general-purpose `exec`, user, firewall, mount, or cron management;
- no third-party package repositories or image pulls;
- private keys and plaintext credentials are rejected by repository validation;
- Hiera eyaml remains opt-in and keys stay outside Git;
- backups and CA data remain sensitive control-plane material.

Encrypted values can still appear in catalog/report contexts if manifests do not
use Puppet's `Sensitive` type appropriately. Every future secret-consuming
profile therefore requires its own threat model and tests.
