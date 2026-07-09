# Rollback operations

Rollback is a new reviewed commit, not a force-reset of a published branch.
Prepare a branch whose tree matches a known revision:

```bash
./scripts/prepare-rollback.sh --revision v0.3.0
```

The script creates a separate worktree and a `rollback/<timestamp>-<revision>`
branch descended from `main`. Review its commit and tests, merge it into `main`,
then use the normal `main -> test -> production` promotion path.

For a deployment-only problem where Git branches are already correct, redeploy:

```bash
sudo ./scripts/deploy-environment.sh --environment production --branch production
```

Never delete the current CA, certificates, PuppetDB database, or agent SSL
state as an application-code rollback technique.
