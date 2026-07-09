# Migration vom lokalen Betrieb

1. Lokalen No-op und Apply auf einem repräsentativen System abschließen.
2. Puppet Server aufbauen und prüfen.
3. Branch `production` schützen, pushen und deployen.
4. Lokalen Timer/Job auf dem Agent stoppen.
5. Letzten lokalen No-op sichern.
6. Agent mit eindeutigem Certname zentral anbinden.
7. CSR unabhängig prüfen und signieren.
8. Zentralen No-op mit dem lokalen Ergebnis vergleichen.
9. Einmal manuell anwenden und erst dann den Agent-Dienst aktivieren.
10. Prüfen, dass die Markerdatei `management_mode=puppet-server` enthält.

Für ein Rollback den Agent-Dienst deaktivieren und den lokalen Weg verwenden. Lokales Apply und zentraler Agent dürfen nicht parallel laufen.
