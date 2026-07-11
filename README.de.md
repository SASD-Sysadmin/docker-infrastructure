# puppet-software-baseline

[English documentation](README.md)

> **Status:** Milestone 11 abgeschlossen (`0.11.0`). Die per-Node-Hiera-eyaml-Hierarchie ist aktiv und besitzt einen eng begrenzten Debian-APT-Kennwortverbraucher.

Konservatives Puppet-Control-Repository zur Installation geprüfter Anwendungen und zur konsistenten Verwaltung von Paketen, Dateien, Diensten, Lifecycle, Betrieb und verschlüsselten Konfigurationswerten.

## Höhepunkte

- aktive Hiera-5-Ebene mit `eyaml_lookup_key`;
- festgelegtes Hiera-eyaml 5.0.1 und PKCS7-Schlüssel außerhalb von Git;
- Debian-only-Rolle `apt_repository_client`;
- feste rootgeschützte APT-Auth-Datei mit Sensitive-EPP;
- Policy-, Verschlüsselungs-, Recovery-, RSpec-, Smoke- und CI-Tests;
- keine automatische Paketquelle, keine Signaturschlüssel und keine hochwertigen Secrets.

## Erste Befehle

```bash
./scripts/validate.sh
python3 scripts/check_secure_data_policy.py
sudo ./scripts/verify-hiera-eyaml.sh --mode server
```

## Dokumentation

- [Milestone 11](docs/de/milestone-11.md)
- [Runbook](docs/de/milestone-11-runbook.md)
- [Hiera-eyaml-Betrieb](docs/de/hiera-eyaml-operations.md)
- [APT-Repository-Kennwort](docs/de/apt-repository-credentials.md)
- [Recovery verschlüsselter Daten](docs/de/secure-data-recovery.md)
- [Roadmap](docs/de/roadmap.md)

## Lizenz

MIT – siehe [LICENSE](LICENSE).
