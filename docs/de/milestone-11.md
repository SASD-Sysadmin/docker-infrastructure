# Milestone 11 – aktive verschlüsselte Hiera-Daten

Milestone 11 aktiviert die zuvor vorbereitete Hiera-eyaml-Ebene und führt genau
einen eng begrenzten Verbraucher ein: ein maschinenbezogenes, nur lesendes
APT-Repository-Kennwort auf zentral verwalteten Debian-Systemen.

## Geliefert

- aktive per-Node-Hierarchie mit `eyaml_lookup_key`;
- festgelegtes `hiera-eyaml` 5.0.1 und Schlüsselprüfung;
- `profile::apt_repository_credentials` und `role::apt_repository_client`;
- automatische Umwandlung in `Sensitive` und Sensitive-EPP-Ausgabe;
- fester rootgeschützter APT-Auth-Pfad mit `show_diff => false`;
- Policy-, Verschlüsselungs-, Schlüssel-, RSpec-, Smoke- und CI-Tests;
- Runbooks für Schlüsselverwahrung, Rotation, Recovery und Restrisiken.

Das Profil richtet keine Paketquelle und keinen Signaturschlüssel ein. Der
Klarwert kann trotz Hiera-eyaml im Puppet-Katalogcache vorhanden sein. Deshalb
ist zunächst nur ein austauschbares, maschinenbezogenes Lesekennwort zulässig.
