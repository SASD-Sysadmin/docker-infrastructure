# ADR 0044: Activate per-node Hiera-eyaml

## Decision

Enable one environment-level `eyaml_lookup_key` hierarchy before normal
per-node data, using the pinned PKCS7 keypair outside Git and disabled decrypted
caching.

## Consequences

Every compiler needs `hiera-eyaml` 5.0.1 and the matching private key. Missing
per-node eyaml files are normal. A broken key deployment can block encrypted
lookups, so promotion and recovery tests are mandatory.
