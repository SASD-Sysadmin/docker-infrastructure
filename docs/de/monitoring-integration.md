# Monitoring-Anbindung

Die Puppet-Server-Rolle enthält nun `profile::monitoring_bridge`. Alle 15 Minuten entstehen unter `/var/lib/sasd-puppet/monitoring` die geschützten Dateien `compliance.json`, `health.json` und `sasd_puppet.prom`. Die Prometheus-Ausgabe enthält nur aggregierte Zustände und ausdrücklich keine Certnames als Labels.

Prometheus, node_exporter, Grafana, Listener, Firewallregeln und Alarmwege werden nicht installiert. Die unabhängige Monitoring-Plattform kann die Textdatei nach einer Berechtigungsprüfung übernehmen.
