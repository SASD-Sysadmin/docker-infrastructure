# Environments and promotion

Milestone 4 uses three branches with identical environment names:

```text
main        integration
  | promote
  v
test        catalog and agent validation
  | promote
  v
production  approved release
```

r10k maps each branch to the same-named Puppet environment. Promotion is
fast-forward only; no normal workflow rewrites `test` or `production` history.

## Promote to test

```bash
./scripts/promote-environment.sh --from main --to test --full-validation
./scripts/promote-environment.sh --from main --to test --push
sudo ./scripts/deploy-environment.sh --environment test --branch test
```

Assign only explicit test nodes to `environment = test`. Review at least one
no-op and one idempotent apply before production promotion.

## Promote to production

```bash
./scripts/promote-environment.sh --from test --to production --full-validation
./scripts/promote-environment.sh --from test --to production --push
sudo ./scripts/deploy-environment.sh --environment production --branch production
```

## Prohibited shortcuts

- force-pushing test or production;
- promoting main directly to production;
- deploying a differently named branch into an environment;
- bypassing validation because a change appears small;
- automatic production deployment from an unauthenticated webhook.
