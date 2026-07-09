# Milestone-9-Runbook

## 1. Rolle auswählen

Wähle genau eine der Rollen `java_development`, `php_development` oder `polyglot_development`. SDK-Klassen dürfen nicht dynamisch über Hiera eingebunden werden.

## 2. Knotendaten anlegen oder ändern

```bash
ruby scripts/manage-node.rb register \
  --certname dev01.example.net \
  --role java_development \
  --owner development \
  --description "Java development host"
```

Bei einem vorhandenen Knoten wird die geprüfte YAML-Datei geändert und validiert.

## 3. Validieren und promoten

```bash
./scripts/validate.sh
./scripts/promote-environment.sh --from main --to test
```

Führe im Test-Environment einen No-op auf dem ausgewählten Knoten aus, prüfe die Paketänderungen und promote danach `test` nach `production`.

## 4. Knoten prüfen

```bash
sudo puppet agent -t --noop
sudo puppet agent -t
sudo sasd-sdk-status --json
cat /etc/sasd/applications.d/assigned.conf
```

## 5. Rücknahme

Stelle den Knoten über den normalen Promotion-Weg auf die vorherige Rolle zurück. Pakete werden nicht automatisch entfernt: Die Profile garantieren Anwesenheit, nicht Abwesenheit. Eine Paketbereinigung benötigt eine eigene geprüfte Änderung.
