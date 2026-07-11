# Betriebsmodell

`main` enthält geprüfte Entwicklung, `test` ist die Vorproduktion und
`production` der freigegebene Sollzustand. Promotion erfolgt ausschließlich
über beide Stufen; r10k deployed anschließend das gleichnamige Environment.

Zentrale Agents laufen nach Zertifikatsfreigabe über den nativen Paketdienst.
Die Rolle `puppet_server` installiert kompaktes Reporting und einen Health-Timer.
PuppetDB ist optional, aber bei Aktivierung kritische Control-Plane-Infrastruktur.

Lokaler und zentraler Apply dürfen auf demselben Rechner nicht parallel laufen.
