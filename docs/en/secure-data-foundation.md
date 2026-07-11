# Secure-data foundation — active in Milestone 11

The per-node Hiera-eyaml hierarchy is active. Every Puppet compiler must have
`hiera-eyaml` 5.0.1 and the external PKCS7 keypair before v0.11.0 is deployed.
Missing encrypted files are normal for nodes that consume no secret.

Hiera-eyaml protects the repository copy. `lookup_options` converts the first
password parameter to `Sensitive`, and Sensitive EPP redacts routine reports.
The compiled/cached catalog can still contain plaintext, so the accepted scope
is one replaceable machine read-only APT credential. High-value keys are out of
scope.

See [Hiera-eyaml operations](hiera-eyaml-operations.md), [APT repository
credentials](apt-repository-credentials.md), and [secure-data
recovery](secure-data-recovery.md).
