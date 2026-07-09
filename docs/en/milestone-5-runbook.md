# Milestone 5 runbook

## Add a development node

1. Complete central-agent enrollment and manual certificate signing.
2. Create `data/nodes/<certname>.yaml` with `sasd::role: development`.
3. Run package/role/complete validation.
4. Commit to a feature branch and merge to `main` after CI.
5. Promote `main -> test`; deploy test.
6. Run `puppet agent -t --noop --environment test` on a representative node.
7. Apply test and verify the second run is unchanged.
8. Promote `test -> production`; deploy production.
9. Change the node's configured environment only through the documented onboarding/activation process if it was pinned to test.
10. Confirm compact report status and `/etc/sasd/applications.d/assigned.conf`.

## Add a package

Use the procedure in `application-profiles.md`. Never place the same package in two groups merely because two roles need it; roles compose shared profiles.

## Release 0.5.x

```bash
./scripts/release-readiness.sh --strict --require-branch main
python3 scripts/generate-release-manifest.py
python3 scripts/verify-release-manifest.py dist/release-manifest.json
git tag -a v0.5.0 -m 'Milestone 5: application baselines and release assurance'
```

Push the tag only after branch promotion/test evidence is recorded. The tag workflow produces reviewable artifacts; production deployment remains manual.
