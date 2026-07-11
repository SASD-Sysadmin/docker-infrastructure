# Release-Absicherung

## Freigabe-Gate

```bash
./scripts/release-readiness.sh --require-branch main --output dist/readiness.json
```

Geprüft werden sauberer Arbeitsbaum, semantische Version, Rollenkatalog, Paketregeln und Repository-Struktur. `--strict` verlangt zusätzlich alle externen Prüfprogramme der CI.

## Dateimanifest

```bash
python3 scripts/generate-release-manifest.py --output dist/release-manifest.json
python3 scripts/verify-release-manifest.py dist/release-manifest.json
```

Das Manifest enthält Version, Commit, Anzahl, Größe und SHA-256 aller versionierten Dateien. Es erkennt unvollständige oder veränderte Release-Bäume, ist aber keine kryptographische Signatur und weist keine Autorenidentität nach.
