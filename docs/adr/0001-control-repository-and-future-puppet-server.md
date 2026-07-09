# ADR 0001: Control repository prepared for a future Puppet Server

- **Status:** Accepted
- **Date:** 2026-07-09

## Context

SASD needs a smaller configuration-management repository focused on application installation and the persistent consistency of packages, files, configuration, and services. Operational troubleshooting and procedural repairs are handled by other repositories.

Early development should remain possible on a local test system with `puppet apply`. The expected long-term operating model includes a central Puppet Server.

## Decision

The repository is structured as a Puppet control repository from its first commit.

- `manifests/site.pp` is the environment entry point.
- `site-modules/` contains organization-specific roles and profiles.
- `modules/` is reserved for external dependencies installed from `Puppetfile` by r10k.
- `data/` and `hiera.yaml` provide environment-level Hiera data.
- local `puppet apply` is a development and transition mechanism, not the final production distribution model.
- a future Puppet Server will compile catalogs for agents.
- r10k will deploy the control repository and its external modules.

## Consequences

### Positive

- Local experiments do not require an immediate server build.
- Puppet code and data can move to the server without reorganizing the repository.
- Agents will eventually require neither Git nor a local clone of the control repository.
- Branch-based environments and centralized validation remain possible.

### Trade-offs

- Bootstrap logic must distinguish local development, server installation, and agent enrollment.
- Certificate authority operations become a critical security and recovery concern.
- The final classification mechanism and branch-to-environment mapping must be designed before production deployment.
- Puppet Server and optional PuppetDB add infrastructure that requires monitoring, backups, and maintenance.

## Alternatives considered

### Permanent masterless operation

Rejected as the target model because repository distribution, reporting, certificate-based identity, and consistent scheduling would remain decentralized.

### Immediate Puppet Server implementation

Deferred because the project first needs a reviewed baseline model, supported platform list, and safe development workflow.
