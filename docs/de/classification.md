# Node-Klassifizierung

Hiera liefert `sasd::role`. `manifests/site.pp` ordnet den Wert über eine feste `case`-Allowlist einer Rollenklasse zu. Milestone 3 erlaubt ausschließlich `baseline`.

Knotenspezifische Dateien tragen den vertrauenswürdigen Certname, zum Beispiel `data/nodes/node01.example.test.yaml`. Klassen dürfen nicht dynamisch aus beliebigen Hiera-Strings inkludiert werden. Eine neue Rolle benötigt Manifest, Profile, Tests, Dokumentation und Release-Prüfung.
