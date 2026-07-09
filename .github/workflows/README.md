# GitHub Actions

`validate.yml` runs the complete Milestone 2 source and catalog suite for both
Puppet 7.23 and Puppet 8.10.

`integration.yml` uses disposable Debian 12, Debian 13, and Ubuntu 24.04
containers. It applies the baseline twice, verifies packages and the marker,
and checks idempotent content. The integration workflow runs only when relevant
paths change or when manually dispatched.
