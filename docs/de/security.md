# Sicherheitsarchitektur

## Aktuelle Kontrollen

- kein produktiver Workload in Milestone 1;
- No-op als Standard der lokalen Ausführung;
- isolierte temporäre Puppet-Laufzeitverzeichnisse;
- Katalogkompilierung mit strikten Variablen;
- festgelegte Entwicklungsabhängigkeiten;
- noch keine externen Puppet-Module;
- strukturelle Prüfung gegen typische Secret-Dateiendungen;
- nur lesende GitHub-Actions-Berechtigungen;
- Validierung vor Merge;
- Lokale Git-Revision oder sichtbarer VERSION-Fallback über `config_version`.

Kennwörter, Tokens, private Schlüssel, privates Zertifikatsmaterial, Wiederherstellungscodes und unverschlüsselte sensible Hiera-Werte dürfen niemals committed werden.

Vor Produktivbetrieb folgen Branch Protection, Deployment-Zugang, CA-Prozess, verschlüsseltes Hiera mit getrenntem Schlüsselmanagement, Backups, Audit-Aufbewahrung, Monitoring und getestete Wiederherstellung.
