# Sicherheitsarchitektur

## Vertrauensgrenzen

Das Control Repository kann später privilegierte Änderungen auf allen eingebundenen Nodes verursachen. Ein fehlerhafter Merge, eine kompromittierte Abhängigkeit, ein gestohlener Deployment-Zugang oder ein Verlust des Puppet-CA-Schlüssels kann daher weitreichende Auswirkungen haben.

## Notwendige Kontrollen vor dem Produktivbetrieb

- geschützter Produktionsbranch;
- verpflichtendes Review durch berechtigte Maintainer;
- fest versionierte und geprüfte Abhängigkeiten;
- minimale Rechte für r10k-Deployment-Zugänge;
- stark eingeschränkter Zugriff auf Puppet Server und CA-Schlüssel;
- verschlüsselte und separat geregelte Secret-Verwaltung;
- isolierte Tests vor der Produktionsfreigabe;
- Backups mit erprobter Wiederherstellung;
- Überwachung von Kompilierungsfehlern und veralteten Agents;
- dokumentiertes Not-Aus für Deployments.

## Zertifizierungsstelle

Die Puppet-CA stellt die Identität der Nodes sicher. Private CA-Daten gehören niemals in dieses Repository. Der Server-Meilenstein muss Registrierung, Signierung, Erneuerung, Widerruf, Backup, Restore und das Vorgehen bei Kompromittierung beschreiben.

## Hiera-Secrets

Normale YAML-Dateien in Git sind nur für nicht sensible Daten geeignet. Eine spätere Entscheidung legt Verschlüsselungsmethode, Schlüsselablage, Berechtigte und Rotation fest.
