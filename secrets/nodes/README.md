# Per-node encrypted data

Only reviewed `.eyaml` files named after a trusted Puppet certname belong here.
The first supported secret key is:

```yaml
profile::apt_repository_credentials::password: >
  ENC[PKCS7,...]
```

Never commit plaintext, private keys, decrypted editor files, backup archives,
or credentials for human accounts. See `docs/en/hiera-eyaml-operations.md` and
`docs/de/hiera-eyaml-operations.md`.
