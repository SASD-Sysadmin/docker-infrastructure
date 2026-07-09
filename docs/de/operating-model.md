# Betriebsmodell

## Standalone-Phase — Milestone 2

Jeder Labor-Knoten besitzt einen lokalen Clone, Puppet-Kommandozeilenwerkzeuge
und r10k. Ein Administrator aktualisiert und validiert, prüft den No-op-Bericht
und entscheidet ausdrücklich über `--apply`. Periodische `puppet agent`-Dienste
sind deaktiviert, weil noch kein Puppet Server vorhanden ist.

```text
Administrator -> Git/r10k -> Validierung -> No-op -> Prüfung -> Apply
```

## Spätere zentrale Phase

Der Puppet Server deployt dann allein das Control Repository. Agents liefern
Fakten und erhalten authentifizierte, kompilierte Kataloge. Die lokalen Skripte
bleiben für Entwicklung und kontrollierte Wiederherstellung erhalten.
