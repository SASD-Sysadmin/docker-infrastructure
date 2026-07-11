# Certificate management

Puppet agents and the server use mutually authenticated TLS. Possession of a signed agent certificate authorizes the holder to identify as that certname, so CA actions are security-sensitive.

## List

```bash
sudo ./scripts/list-certificates.sh
sudo ./scripts/list-certificates.sh --all
```

## Sign one request

```bash
sudo ./scripts/sign-certificate.sh --certname node01.example.test
```

The wrapper displays the matching pending request and signs only that certname. Autosigning remains `false`.

## Revoke and delete

```bash
sudo ./scripts/clean-certificate.sh \
  --certname node01.example.test \
  --confirm node01.example.test
```

Then on the agent:

```bash
sudo puppet ssl clean
```

Re-enroll only after confirming that no old machine can still use copied keys.

## CA backup

The CA private key is among the most sensitive assets in the deployment. Back up the active Puppet `ssldir` (print it with `puppet config print ssldir`) encrypted, offline, and with tested restore permissions. Never store it in this repository.

## Prohibited shortcuts

- wildcard/basic autosigning;
- signing unknown or unverified CSRs;
- copying an agent SSL directory to another node;
- deleting the server SSL directory to fix an ordinary agent problem;
- committing any `.pem`, `.key`, `.p12`, `.pfx`, or keystore file.
