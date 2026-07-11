# ADR 0047: Hiera-eyaml key rotation is staged, not automatic

The repository can generate and verify a candidate keypair but does not replace
active keys or rewrite encrypted data automatically. Rotation requires backup,
complete re-encryption, test-environment compilation, coordinated compiler key
deployment, and an explicit production promotion.
