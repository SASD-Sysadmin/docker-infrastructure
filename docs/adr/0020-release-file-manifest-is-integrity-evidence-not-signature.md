# ADR 0020: Release file manifest is integrity evidence, not a signature

## Decision
Releases include a deterministic SHA-256 file manifest tied to version and commit.

## Consequences
Consumers can detect missing or modified files. Authenticity still depends on trusted Git hosting, protected branches/tags, or a future signing mechanism.
