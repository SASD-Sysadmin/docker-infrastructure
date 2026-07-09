# Standalone-Bootstrap

## Empfohlener erster Einsatz

Zuerst in einer VM mit Snapshot prüfen:

```bash
sudo ./scripts/bootstrap-agent.sh --noop
```

Das Skript prüft die Plattform, aktualisiert APT, installiert Grundpakete, Git,
`puppet-agent` und r10k, deaktiviert periodischen Agentbetrieb, klont oder
aktualisiert das Repository unter `/opt/sasd`, verarbeitet das Puppetfile,
validiert alles und führt einen No-op-Katalog aus.

Eine echte Anwendung erfolgt nur ausdrücklich:

```bash
sudo ./scripts/bootstrap-agent.sh --apply
```

Milestone 2 verwendet Distributionspakete, weil die aktuellen Puppet-Core-
Paketquellen authentifizierten Zugriff benötigen. Für den lokalen Testbetrieb
werden keine Zugangsdaten im Skript oder Repository gespeichert.

Das Skript verweigert nicht unterstützte Systeme, schmutzige Git-Clones,
existierende Nicht-Git-Ziele, nicht lineare Updates und reale Ausführung ohne
root. Es löscht niemals eigenmächtig ein Zielverzeichnis.
