# ADR 0017: Reviewed application package groups

## Decision
Application installation is separated into baseline, administration, development, and container-tool profiles. Each package has one owning group and comes from configured distribution repositories.

## Consequences
Roles can compose reusable groups without duplicate package ownership. Upstream installers and third-party repositories require separate future decisions.
