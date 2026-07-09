# Security policy

## Supported versions

Milestone `0.3.x` is the currently maintained repository line.

## Never commit

- private keys or certificates;
- Puppet CA/agent SSL directories;
- Forge/Puppet Core API keys;
- Git deploy keys or access tokens;
- passwords, Hiera eyaml private keys, keystores, or unredacted production reports.

Repository validation rejects common secret-bearing file extensions, but that is not a substitute for review and secret scanning.

## Puppet trust model

- Autosigning is disabled.
- Every CSR must be independently associated with an intended inventory node.
- Certnames are unique and stable.
- CA backup is encrypted, offline, access-controlled, and restore-tested.
- An existing CA must not be deleted or regenerated as casual troubleshooting.
- Agents remain disabled until signed and explicitly activated.

## Code deployment

Only reviewed code promoted to `production` may be deployed to the production environment. Do not edit generated r10k environments. Protect both Git branches and tags; use least-privilege repository credentials on the server.

## Reporting vulnerabilities

Report security issues privately to the repository owner. Include affected version, reproduction, impact, and whether credentials or certificates may have been exposed. Do not open a public issue containing secrets.
