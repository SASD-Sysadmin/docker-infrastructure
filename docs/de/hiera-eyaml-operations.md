# Hiera-eyaml-Betrieb

## Jeden Compiler vorbereiten

```bash
sudo ./scripts/setup-hiera-eyaml.sh --mode server --apply
sudo ./scripts/verify-hiera-eyaml.sh --mode server
```

Der private Schlüssel bleibt unter `/etc/sasd-puppet/eyaml` und gehört nur in
das sensible Offline-Control-Plane-Backup. Arbeitsplätze benötigen zum
Verschlüsseln grundsätzlich nur den öffentlichen Schlüssel.

## Wert ohne Übergabe als Kommandozeilenargument verschlüsseln

```bash
printf '%s' "$SECRET" | ./scripts/encrypt-hiera-value.sh   --public-key /secure/public_key.pkcs7.pem   --label apt-repository-password
```

Nur den Block `ENC[PKCS7,...]` nach
`secrets/nodes/<trusted-certname>.eyaml` übernehmen.

## Rotation

```bash
sudo ./scripts/stage-hiera-eyaml-key-rotation.sh   --output-directory /srv/secure/eyaml-rotation-2026   --confirm /srv/secure/eyaml-rotation-2026
```

Das Skript erzeugt nur einen Kandidaten. Alle Werte müssen isoliert neu
verschlüsselt, in `test` kompiliert und erst danach auf allen Compilern mit dem
neuen Schlüsselpaar aktiviert werden. Eine automatische Rotation ist bewusst
nicht enthalten.
