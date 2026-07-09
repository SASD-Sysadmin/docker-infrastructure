# GitHub Actions

`validate.yml` runs the complete source, structure, security-boundary, catalog,
and RSpec-Puppet suite for the supported Puppet 7 and Puppet 8 development
matrix. It runs for both `main` and `production` so a promoted release branch
cannot bypass validation.

`integration.yml` uses disposable Debian 12, Debian 13, and Ubuntu 24.04
containers. It applies the baseline twice, verifies packages and the marker,
and checks idempotent content. The integration workflow runs only when relevant
paths change or when manually dispatched.

The server and certificate-management scripts are covered by non-destructive
argument and dry-run smoke tests. A real CA or production server is never
created inside GitHub Actions.
