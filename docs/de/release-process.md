# Release-Prozess

Milestone 1 trägt die Repository-Version `0.1.0`.

Für spätere Releases:

1. einen abgegrenzten Stepstone abschließen und prüfen;
2. `bundle exec rake` ausführen;
3. englische und deutsche Betriebsdokumentation aktualisieren;
4. `CHANGELOG.md` und `VERSION` aktualisieren;
5. die Versionen beider `metadata.json` synchron halten, solange beide Site-Module gemeinsam veröffentlicht werden;
6. über einen geprüften Pull Request zusammenführen;
7. einen annotierten Git-Tag wie `v0.2.0` erzeugen;
8. zuerst in einer Testumgebung deployen und No-op-Ausgabe prüfen.

Ein Git-Tag allein ist keine Freigabe für ein Produktiv-Deployment.
