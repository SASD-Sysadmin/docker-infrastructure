# Grundlage für verschlüsselte Hiera-Daten

Hiera eyaml ist in Milestone 6 vorbereitet, aber nicht automatisch aktiv. So
bleiben bestehende Kataloge unabhängig von Backend und Schlüsseldateien.

```bash
sudo ./scripts/setup-hiera-eyaml.sh --mode server
sudo ./scripts/setup-hiera-eyaml.sh --mode server --apply
./scripts/prepare-hiera-eyaml.sh --output /tmp/hiera.yaml.candidate
```

Die festgelegte Version ist `5.0.1`. PKCS7-Schlüssel liegen außerhalb von Git
unter `/etc/sasd-puppet/eyaml`. Auf dem Server ist der private Schlüssel `root:puppet` mit Modus `0640` in einem `0750`-Verzeichnis, damit der Compiler ihn lesen kann; Arbeitsplatzschlüssel bleiben root-only. Er ist hochsensibel und muss getrennt gesichert werden.

Erst Backend auf allen Compilern installieren, Schlüssel sichern, Kandidat
prüfen, Katalogtests ausführen und anschließend die geänderte `hiera.yaml` über
`main -> test -> production` veröffentlichen. In `secrets/` dürfen nur
verschlüsselte `.eyaml`-Dateien liegen.
