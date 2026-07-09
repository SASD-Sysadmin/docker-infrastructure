# Release process

1. Merge reviewed feature work into `main` after CI.
2. Update `VERSION`, module metadata, marker data, changelog, tests, and both languages.
3. Run `bundle exec rake` and applicable integration tests.
4. Create an annotated version tag on the approved main commit.
5. Promote `main` to `test` with `promote-environment.sh`.
6. Deploy `test`; perform representative no-op, apply, and idempotence checks.
7. Promote `test` to `production` with the same script.
8. Push branches/tag and manually deploy production with r10k.
9. Confirm health, reports, agent service, and a fresh verified backup.

Never force-push `test` or `production` and never promote main directly to production.
