# Betriebsmodell

## Milestone 1

Entwickler prüfen lokal und über GitHub Actions. Der einzige Katalog ist eine workload-freie Baseline; es gibt noch keine unbeaufsichtigte Durchsetzung.

## Entwicklungsfluss

```text
Feature-Branch -> bundle exec rake -> Pull Request -> Review -> main
```

## Späterer Produktivfluss

```text
GitHub main -> r10k / Code Manager -> production Environment
             -> Puppet Server -> authentifizierte Agent-Kataloge
```

Agents klonen das Control Repository nicht. Der Server deployt Code, kompiliert Kataloge aus vertrauenswürdigen Facts und Hiera und liefert sie per authentifiziertem TLS aus.

Puppet besitzt den dauerhaften Sollzustand. Diagnose, temporäre Reparaturen, einmalige Migrationen und prozedurales Troubleshooting bleiben außerhalb dieses Repositorys.
