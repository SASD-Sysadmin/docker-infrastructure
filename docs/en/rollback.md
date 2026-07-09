# Rollback

Milestone 2 is additive. It installs packages and creates `/etc/sasd` with one
marker file. It does not remove packages or change services.

## Before apply

Create a VM snapshot and save the no-op output. Record the Git commit with
`git rev-parse HEAD`.

## Code rollback

Check out or redeploy the previous tagged repository version, run validation,
then preview it. A previous catalog does not automatically uninstall packages
added by 0.2.0 because package absence is not declared.

## Marker rollback

The marker can be removed manually only after Puppet enforcement is stopped or
its management is disabled in reviewed Hiera data. Otherwise Puppet recreates
it. Removing `/etc/sasd` is safe only when no later SASD stepstone owns content
below it.

## Package rollback

Package removal is intentionally manual in Milestone 2. Review reverse
dependencies and business use before `apt remove`. Never automate broad removal
from a package-list diff.
