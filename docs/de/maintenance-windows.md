# Wartungsfenster

1. Änderungsticket festlegen.
2. Knoten mit Grund, Ticket und genauer UTC-Ablaufzeit auf `maintenance` setzen.
3. Änderung prüfen und promovieren.
4. Agent einmal manuell ausführen; anschließend ist der periodische Dienst aus.
5. Wartung mit den zuständigen Betriebswerkzeugen durchführen.
6. Knoten auf `active` setzen, promovieren und Agent einmal manuell starten.
7. Report und laufenden Agentdienst kontrollieren.

Abgelaufene Wartungsfenster werden nicht automatisch verlängert, sondern als
Compliance-Warnung gemeldet.
