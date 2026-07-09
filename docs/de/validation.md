# Validierung und Tests

## Gesamte Prüfsuite

```bash
bundle exec rake
```

Der Standard-Rake-Task führt statische Prüfungen, RSpec-Puppet-Tests und einen No-op-Kataloglauf aus.

## Statische Prüfungen

`bundle exec rake validate` ruft `scripts/validate.sh --strict` auf und prüft:

- Bash-Syntax und ShellCheck-Befunde;
- sämtliche YAML- und JSON-Dokumente sowie YAML-Stil mit `yamllint`;
- vorgeschriebene Repository-Dateien, Versionen und Metadatenregeln;
- repository-interne Markdown-Links;
- die workload-freie Sicherheitsgrenze von Milestone 1;
- Puppet-Parser-Validierung;
- EPP-Syntax, sobald Templates vorhanden sind;
- Puppet-Stil mit `puppet-lint`;
- Modulmetadaten mit `metadata-json-lint`.

`./scripts/validate.sh` ohne `--strict` eignet sich für eine erste Arbeitsplatzprüfung: Fehlende externe Puppet-/Ruby-Werkzeuge erzeugen Warnungen, während die eingebauten Prüfungen trotzdem laufen. Im Strict-Modus führt ein fehlendes Pflichtwerkzeug zum Fehler.

## Unit-Tests

RSpec-Puppet kompiliert `profile::baseline` und `role::baseline`, prüft die Abhängigkeit von Rolle zu Profil und stellt sicher, dass neben den strukturellen Ressourcen `Class` und `Stage` keine weiteren Ressourcen im Katalog vorhanden sind.

## Katalog-Smoke-Test

`bundle exec rake catalog` führt `puppet apply --noop` mit isoliertem temporärem `confdir` und `vardir` aus. Der lokale Puppet-Zustand des Entwicklers bleibt unberührt; die detaillierten Puppet-Exitcodes 0 und 2 gelten als erfolgreicher Test.

## Gleichheit von lokaler Prüfung und CI

GitHub Actions installiert ShellCheck und yamllint, stellt die fixierten Ruby-Abhängigkeiten bereit und startet `bundle exec rake`. Lokal und in CI gilt damit derselbe oberste Abnahmebefehl.
