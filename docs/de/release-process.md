# Release-Prozess

Änderungen werden zunächst über Feature-Branch und Pull Request nach `main` integriert. Version, Modulmetadaten, Marker, Changelog, Tests und Dokumentation werden gemeinsam angepasst. Nach vollständiger Prüfung erhält der freigegebene Commit einen annotierten Tag und wird kontrolliert nach `production` übernommen. Danach erfolgt das manuelle r10k-Deployment und zunächst ein No-op auf einem repräsentativen Agent.

`production` darf im normalen Release-Prozess nicht auf einen ungeprüften Commit zeigen oder per Force-Push verändert werden.
