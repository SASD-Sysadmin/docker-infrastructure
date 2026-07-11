# PuppetDB-Aufbewahrung und Deaktivierung

Der geprüfte Kandidat verwendet `node-ttl=7d`, `node-purge-ttl=30d`, `report-ttl=14d` und `resource-events-ttl=14d`. Das Repository installiert ihn nicht automatisch. Ausgemusterte Knoten werden exakt bestätigt deaktiviert, nicht sofort gelöscht; die Historie bleibt bis zum Ablauf der Purge-Frist erhalten.
