# Grenze für SELinux und Firewall

Milestone 7 unterstützt EL9 als Agent-Plattform, schwächt aber keine Sicherheitskontrollen. Das Repository führt weder `setenforce`, `setsebool`, `semanage` noch `firewall-cmd` aus, installiert keine SELinux-Module, öffnet keine Ports und aktiviert kein EPEL. Standortabhängige Ausnahmen benötigen eine eigene geprüfte Änderung mit Begründung, Test und Rückfallplan.
