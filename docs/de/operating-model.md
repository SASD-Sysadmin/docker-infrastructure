# Betriebsmodell

## Phase 1: lokale Entwicklung

Ein Maintainer entwickelt und validiert den Code in einem Klon des Repositorys. Puppet kann auf einem isolierten Laborsystem lokal ausgeführt werden, möglichst zunächst im No-op-Modus.

Die späteren lokalen Werkzeuge sollen Syntax und Hiera-Daten prüfen, parallele Läufe verhindern, Commit und Rückgabecode protokollieren und ohne ausdrückliche Apply-Option keine Änderungen vornehmen.

## Phase 2: zentraler Puppet Server

Der Puppet Server wird zum maßgeblichen Katalog-Compiler. r10k stellt freigegebene Revisionen bereit. Agents authentifizieren sich, übertragen Fakten, laden Kataloge, wenden sie an und senden Reports.

## Trennung der Bootstrap-Aufgaben

Drei Aufgaben bleiben getrennt:

1. **Entwickler-Bootstrap** für lokale Prüf- und Testwerkzeuge.
2. **Puppet-Server-Bootstrap** für Git, Puppet Server, r10k und später optional PuppetDB.
3. **Agent-Bootstrap** für Puppet Agent, Serveradresse, Zertifikatsvertrauen und Agent-Dienst.

Im endgültigen Betriebsmodell benötigt ein Agent Git nicht allein für die Puppet-Konfigurationsverteilung.

## Freigabe einer Änderung

Vor der produktiven Übernahme werden Code und Daten geprüft, repräsentative Kataloge kompiliert, No-op und Test-Apply ausgeführt, Idempotenz und Dienstzustand kontrolliert und anschließend eine unveränderliche geprüfte Revision bereitgestellt.
