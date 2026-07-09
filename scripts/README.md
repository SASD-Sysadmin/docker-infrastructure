# Scripts

## Standalone mode

- `bootstrap-agent.sh`, `apply-local.sh`, `update-local.sh`, `status-local.sh`.

## Central server and code

- `bootstrap-server.sh` installs a fresh server safely.
- `deploy-environment.sh` performs a locked explicit r10k deployment.
- `status-server.sh` reports read-only central status.

## Central agents and CA

- `bootstrap-central-agent.sh` installs/configures and submits a CSR.
- `activate-central-agent.sh` retrieves the signed cert, tests, and enables service.
- `list-certificates.sh`, `sign-certificate.sh`, `clean-certificate.sh` wrap exact CA actions.

All mutating scripts require root where appropriate, reject unsupported platforms or malformed identities, and default to conservative/manual behavior. Review the matching documentation before production use.
