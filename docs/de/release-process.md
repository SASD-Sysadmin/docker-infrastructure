# Release-Prozess

Code, Tests, `VERSION`, Modulmetadaten, Rollenkatalog, Marker, Changelog und beide Sprachbäume werden gemeinsam aktualisiert. Danach folgen Paket-/Rollenprüfung, `bundle exec rake`, relevante Container-Integration, striktes Readiness-Gate, Dateimanifest und Checkliste. Erst dann wird ein annotiertes `v<VERSION>`-Tag erzeugt und über `main -> test -> production` mit repräsentativem No-op, Apply und Idempotenztest promoted. Das Produktionsdeployment mit r10k bleibt manuell.
