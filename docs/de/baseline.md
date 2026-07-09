# Baseline von Milestone 2

Die Paketliste ist klein und verwendet ausschließlich Standardquellen der
Distribution. `common.yaml` enthält gemeinsame Werkzeuge; Familie, Produkt und
Release ergänzen Unterschiede. Arrays werden eindeutig zusammengeführt.

Das Entfernen eines Paketnamens aus Hiera deinstalliert das Paket **nicht**.
Milestone 2 nutzt `ensure => installed` und keine Purge-Policy. Eine Entfernung
muss später ausdrücklich entworfen und geprüft werden.

`/etc/sasd/puppet-baseline.conf` weist Datei-Ownership, Template-Rendering und
plattformabhängige Kataloge nach. Sie enthält weder Secrets noch ausführbare
Konfiguration. Manuelle Änderungen werden beim nächsten Apply ersetzt.
