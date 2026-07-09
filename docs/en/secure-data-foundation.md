# Secure-data foundation

Milestone 6 prepares Hiera eyaml but keeps it disabled by default. Existing
catalogs therefore do not depend on an uninstalled backend or missing key.

## Why opt-in

Encrypted values are safe only when key custody, backup, rotation, compiler
installation, access control, reporting behavior, and recovery have been
agreed. Encryption is not permission management.

## Install and create keys

Dry run:

```bash
sudo ./scripts/setup-hiera-eyaml.sh --mode server
```

Apply:

```bash
sudo ./scripts/setup-hiera-eyaml.sh --mode server --apply
```

The pinned version is `5.0.1`. Private and public PKCS7 material is created
under `/etc/sasd-puppet/eyaml`, outside Git. On a server the private key is `root:puppet` mode `0640` inside a `0750` directory so the compiler can read it; workstation keys remain root-only. Back it up as sensitive control-plane material.

For an administrator workstation use `--mode workstation` and a separate,
protected key directory.

## Prepare the hierarchy

```bash
./scripts/prepare-hiera-eyaml.sh --output /tmp/hiera.yaml.candidate
```

Review `config/hiera-eyaml.yaml.example`, key paths, compiler installation, and
catalog tests. Only then replace `hiera.yaml` in a reviewed commit and promote
it through all environments.

Only encrypted `.eyaml` files belong under `secrets/`. Never commit private
keys, decrypted scratch files, cleartext tokens, or backup archives.
