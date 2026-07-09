# ADR 0028: Package names live in OS-family Hiera

## Status
Accepted.

## Decision
Application profiles receive complete package arrays from `data/os/family/Debian.yaml` or `data/os/family/RedHat.yaml`. Common data contains empty defaults.

## Consequences
Manifests remain platform-neutral apart from explicit support guards. Every family map is reviewed and tested independently; differences are visible rather than hidden in conditional code.
