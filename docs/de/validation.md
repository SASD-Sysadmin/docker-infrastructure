# Validierung und Tests

```bash
bundle exec rake
```

Die Gesamtsuite prüft Shell, YAML, JSON, Struktur, Links, Secret-Dateitypen, die
Paket-/Datei-Sicherheitsgrenze, Bootstrap-Fixtures, Puppet-/EPP-Syntax,
puppet-lint, Metadaten, RSpec-Puppet und No-op-Kataloge.

RSpec-Puppet kompiliert Debian 12, Debian 13 und Ubuntu 24.04, prüft Pakete,
Dateirechte, Template-Inhalt und Rollenverkettung und muss Rocky Linux 9
ablehnen.

Für Fixture-Kataloge werden YAML-Fakten nur temporär als hoch gewichtete Custom
Facts geladen. Sie sind bei `--apply` verboten.

Der Container-Test installiert Puppet in einem Wegwerf-Container, wendet die
Baseline zweimal an und prüft Pakete, Markierungsdatei und Idempotenz.
