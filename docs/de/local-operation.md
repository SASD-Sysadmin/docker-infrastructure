# Lokaler Betrieb

## Vorschau

```bash
./scripts/apply-local.sh --noop
```

No-op meldet Abweichungen, ändert aber nichts. Die detaillierten Puppet-
Erfolgscodes 0 und 2 werden als Shell-Erfolg behandelt.

## Anwenden

```bash
sudo ./scripts/apply-local.sh --apply
```

Eine echte Anwendung benötigt root. Gleichzeitige Läufe werden mit `flock`
verhindert, sofern verfügbar. Künstliche Fakten sind nur bei No-op zulässig.

## Aktualisieren

```bash
sudo ./scripts/update-local.sh
sudo ./scripts/update-local.sh --apply
```

Das Update verlangt einen sauberen Git-Stand, verwendet ausschließlich Fast-
Forward, installiert Puppetfile-Module, validiert und startet danach No-op oder
Apply.

## Status

```bash
./scripts/status-local.sh
```
