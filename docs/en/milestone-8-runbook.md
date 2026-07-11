# Milestone 8 runbook

## Daily
1. Check `sasd-puppet-health.timer` and `sasd-puppet-monitoring.timer`.
2. Inspect aggregate monitoring; use protected compliance JSON for node detail.
3. Investigate critical status before promotion.

## Before a release or upgrade
1. Run full repository validation.
2. Generate and verify an audit bundle.
3. Create and verify a control-plane backup.
4. Run upgrade preflight.
5. Promote through `main`, `test`, then `production`.

## Quarterly recovery drill
1. Select the newest verified offline backup.
2. Run recovery readiness.
3. Extract into a new isolated directory.
4. Verify CA identity, environment code, PuppetDB dump, and eyaml custody.
5. Record findings; do not modify live paths.

## Node retirement
1. Mark retired and promote.
2. Clean the CA with exact confirmation.
3. Archive node data.
4. Deactivate in PuppetDB.
5. Keep data until the retention period expires.
