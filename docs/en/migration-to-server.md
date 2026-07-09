# Migration from standalone mode

## Preparation

1. Complete Milestone 2 local no-op/apply tests on representative systems.
2. Build and verify the Puppet Server.
3. Protect and push the `production` branch.
4. Deploy and parser-validate `production`.
5. Ensure each node has a unique stable certname.

## Per-node migration

1. Stop any local timer or scheduler invoking `apply-local.sh`.
2. Run one final local no-op and save its output.
3. Execute `bootstrap-central-agent.sh` with the chosen certname.
4. Independently verify and sign the CSR.
5. Run `activate-central-agent.sh --noop` and compare with the prior local no-op.
6. Apply once manually.
7. Enable the agent service.
8. Confirm `/etc/sasd/puppet-baseline.conf` now says `management_mode=puppet-server`.

## Rollback

Disable the agent service and use the unchanged local scripts/clone. Do not run local apply and central agent simultaneously; both compile the same baseline today, but future data/environment differences can cause oscillation.
