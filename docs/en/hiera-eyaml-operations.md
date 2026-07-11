# Hiera-eyaml operations

## Prepare every compiler

```bash
sudo ./scripts/setup-hiera-eyaml.sh --mode server --apply
sudo ./scripts/verify-hiera-eyaml.sh --mode server
```

The private key remains under `/etc/sasd-puppet/eyaml` and is included only in
the sensitive offline control-plane backup. Workstations need only the public
key to encrypt new values; private-key distribution should be minimized.

## Encrypt without argv leakage

```bash
printf '%s' "$SECRET" | ./scripts/encrypt-hiera-value.sh   --public-key /secure/public_key.pkcs7.pem   --label apt-repository-password
```

Copy only the `ENC[PKCS7,...]` block into
`secrets/nodes/<trusted-certname>.eyaml`. Never put plaintext into Git or shell
history.

## Verify

```bash
sudo ./scripts/verify-hiera-eyaml.sh --mode server --roundtrip
python3 scripts/check_secure_data_policy.py
```

## Rotation

Create an isolated candidate only:

```bash
sudo ./scripts/stage-hiera-eyaml-key-rotation.sh   --output-directory /srv/secure/eyaml-rotation-2026   --confirm /srv/secure/eyaml-rotation-2026
```

This does not activate keys or re-encrypt data. Back up the current keypair,
re-encrypt every `.eyaml` file on an isolated workstation, validate all
catalogs in `test`, install the new pair on every compiler, promote, and keep a
rollback copy until all nodes compile. Automatic rotation is intentionally not
implemented because a partial operation can make every encrypted lookup fail.
