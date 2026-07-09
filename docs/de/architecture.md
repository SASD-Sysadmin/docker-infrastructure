# Architektur

## Geltungsbereich

`puppet-software-baseline` ist die vorgesehene Quelle für den gewünschten Software- und Konfigurationszustand der von SASD verwalteten Systeme. Das Repository beschreibt dauerhafte Konfiguration und keine einmaligen Betriebsabläufe.

## Komponenten

### Control Repository

Das Git-Repository enthält Environment-Manifeste, SASD-eigene Module, Hiera-Daten, Abhängigkeiten, Dokumentation und spätere Prüfwerkzeuge.

### Puppet Server

Der spätere zentrale Server erhält die bereitgestellten Environments über r10k, kompiliert Kataloge aus Manifesten, Modulen, Hiera-Daten und Node-Fakten und liefert sie an authentifizierte Agents aus.

### Puppet Agents

Agents sammeln Fakten, authentifizieren sich über Puppet-Zertifikate, laden ihren Katalog, wenden notwendige Änderungen an und melden das Ergebnis. Sie klonen das Control Repository im Zielbetrieb normalerweise nicht.

### r10k

r10k bildet freigegebene Git-Branches auf Puppet-Environments ab und installiert die im `Puppetfile` festgelegten Abhängigkeiten.

### PuppetDB

PuppetDB ist für den ersten Server-Meilenstein optional. Später kann es Fakten, Kataloge und Reports speichern sowie Inventar- und systemübergreifende Abfragen ermöglichen.

## Codeorganisation

Das Projekt soll das Roles-and-Profiles-Pattern verwenden:

- Ein **Profil** enthält die technische Implementierung eines zusammengehörigen Themas.
- Eine **Rolle** kombiniert Profile entsprechend dem Zweck einer Maschine.
- Ein Node erhält normalerweise genau eine Rolle.
- Hiera liefert Daten an parametrisierte Klassen.

## Klassifizierung

Die anfängliche Hiera-Hierarchie sieht ein Fakt `sasd_role` vor. Dessen Quelle ist noch nicht festgelegt. Produktiver Code darf sich erst darauf verlassen, wenn die Klassifizierungsentscheidung abgeschlossen und dokumentiert ist.
