# Milestone 3 — central Puppet Server

## Goal

Milestone 3 turns the control repository into a centrally usable open-source Puppet deployment without adding application-specific workloads. It provides repeatable installation, code deployment, certificate enrollment, operations, tests, and documentation.

## Delivered components

1. `bootstrap-server.sh` installs and configures Puppet Server and r10k.
2. `deploy-environment.sh` deploys one explicit branch/environment pair under a lock and parser-validates it.
3. `bootstrap-central-agent.sh` installs an agent, writes identity settings, disables its service, and submits a CSR.
4. `sign-certificate.sh`, `list-certificates.sh`, and `clean-certificate.sh` wrap exact CA operations.
5. `activate-central-agent.sh` retrieves the signed certificate, performs a no-op or apply run, and optionally enables the service.
6. `status-server.sh` gives read-only service, version, environment, and deployment status.
7. The `production` Git branch maps directly to the `production` Puppet environment.
8. `sasd::role` is read from Hiera but mapped through a manifest allowlist.

## Explicit non-goals

- PuppetDB and PostgreSQL;
- Puppet Enterprise;
- high availability or compiler nodes;
- automatic CSR signing;
- automatic Git webhooks;
- firewall automation;
- external node classifiers;
- application roles beyond `baseline`;
- automatic CA replacement or certificate renewal workflows.

## Definition of done

Milestone 3 is complete when repository validation passes, all bootstraps have deterministic dry-run tests, the central marker mode has unit coverage, both `main` and `production` are validated by CI, and operators have English and German procedures for install, enrollment, deployment, backup, rollback, and troubleshooting.
