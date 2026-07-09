# Security policy

## Supported versions

Until the first production release, only the current `main` branch receives security fixes.

## Reporting

Do not open a public issue for a vulnerability that exposes credentials, private infrastructure details, certificate material, or a practical exploitation path. Contact the repository owner through a private channel available in the GitHub organization profile.

Include the affected revision, impact, safe reproduction details, and suggested mitigation. Never send real secrets.

## Repository security rules

- no passwords, tokens, private keys, or private certificate material;
- no unencrypted sensitive Hiera data;
- pin third-party modules and development dependencies;
- review no-op output before productive enforcement;
- protect and back up the future Puppet CA independently;
- grant r10k read-only repository access;
- validate every change before deployment.
