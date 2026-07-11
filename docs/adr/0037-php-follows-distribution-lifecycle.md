# ADR 0037: PHP follows the distribution lifecycle

- Status: Accepted
- Date: 2026-07-09

## Decision

Install the command-line PHP SDK supplied by each supported distribution major release. Do not add third-party PHP repositories or switch EL9 module streams automatically.

## Consequences

PHP feature versions differ by platform, but security ownership and package trust remain with the distribution.
