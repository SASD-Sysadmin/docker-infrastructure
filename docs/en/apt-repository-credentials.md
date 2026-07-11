# Encrypted APT repository credential

`role::apt_repository_client` is the first concrete encrypted-data consumer.
Normal node data supplies the repository host and login; the password exists
only in the matching per-node `.eyaml` file.

Normal node data:

```yaml
sasd::role: apt_repository_client
profile::apt_repository_credentials::machine: packages.example.test
profile::apt_repository_credentials::login: sasd-readonly
```

Encrypted data:

```yaml
profile::apt_repository_credentials::password: >
  ENC[PKCS7,...]
```

The profile creates only
`/etc/apt/auth.conf.d/sasd-private-repository.conf`, owned by root with mode
`0600`. It rejects schemes, paths, whitespace, Red Hat-family systems, and
local unauthenticated `puppet apply`. Repository source and signing-key trust
remain separate reviewed changes.
