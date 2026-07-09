# Production readiness

Before a role or package group reaches production:

1. Supported platforms and package availability are documented.
2. Package policy and role catalog pass.
3. Puppet 7 and Puppet 8 unit/catalog tests pass.
4. Relevant container integration reaches an unchanged second run.
5. A representative signed node completes no-op without unexpected removals.
6. Test environment apply succeeds and compact reports remain healthy.
7. Backup verification is current.
8. Rollback target and operator are known.
9. `RELEASE_CHECKLIST.md` is completed.
10. `test` is fast-forward promoted to `production` and manually deployed.

A successful syntax check alone is not production approval. Package transactions can still fail because of mirrors, locks, disk space, held packages, or local repository policy.
