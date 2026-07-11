# ADR 0027: EL9 agents require Puppet Core packages

## Status
Accepted for Milestone 7.

## Decision
AlmaLinux 9 and Rocky Linux 9 are supported as central Puppet agents only. Their bootstrap requires the authenticated Puppet Core EL9 repository. No unreviewed distro/EPEL fallback is implemented.

## Consequences
A Forge API key and credential-rotation process are required. Standalone local bootstrap remains Debian/Ubuntu only. Puppet Server support is unchanged.
