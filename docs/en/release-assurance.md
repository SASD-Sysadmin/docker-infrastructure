# Release assurance

## Readiness gate

```bash
./scripts/release-readiness.sh --require-branch main --output dist/readiness.json
```

The gate requires a clean worktree, semantic version, matching role catalog, valid package policy, and repository validation. `--strict` additionally requires every external validator available in CI.

## File manifest

```bash
python3 scripts/generate-release-manifest.py --output dist/release-manifest.json
python3 scripts/verify-release-manifest.py dist/release-manifest.json
```

The manifest records the release version, Git commit, file count, size, and SHA-256 for every tracked file except the output itself. It detects incomplete or modified release trees; it is not a cryptographic signature and does not establish author identity.

## CI artifact

A tag matching `v*` triggers `.github/workflows/release.yml`. It performs full validation, confirms `v<VERSION>`, generates source archives and checksums, generates/verifies the file manifest, and uploads an immutable workflow artifact for review. Publishing a public GitHub Release remains a deliberate manual action.
