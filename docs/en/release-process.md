# Release process

1. Update code, tests, `VERSION`, module metadata, role catalog, marker version, changelog, and both language trees.
2. Run package and role policy checks.
3. Run `bundle exec rake` and relevant container integration.
4. Run `release-readiness.sh --strict --require-branch main`.
5. Generate and verify the release file manifest.
6. Complete `RELEASE_CHECKLIST.md`.
7. Create an annotated `v<VERSION>` tag on the approved main commit.
8. Promote `main -> test`; deploy and verify representative no-op/apply/idempotence.
9. Promote `test -> production`; push branches/tag and manually deploy production with r10k.
10. Confirm health, reports, agent convergence, and a fresh verified backup.

Never force-push `test` or `production`, never promote main directly to production, and never treat the generated hash manifest as an author signature.
