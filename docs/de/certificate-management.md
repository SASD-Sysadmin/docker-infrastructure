# Zertifikatsverwaltung

Puppet verwendet gegenseitig authentifiziertes TLS. Ein signiertes Agent-Zertifikat berechtigt seinen Besitzer, unter diesem Certname aufzutreten. CA-Aktionen sind deshalb sicherheitskritisch.

```bash
sudo ./scripts/list-certificates.sh
sudo ./scripts/list-certificates.sh --all
sudo ./scripts/sign-certificate.sh --certname node01.example.test
```

Bereinigung nur mit exakter Bestätigung:

```bash
sudo ./scripts/clean-certificate.sh   --certname node01.example.test   --confirm node01.example.test
```

Anschließend auf dem Agent `sudo puppet ssl clean` ausführen und neu anbinden.

Der gesamte SSL-/CA-Bestand im aktiven `ssldir` (`puppet config print ssldir`) muss verschlüsselt, offline und mit getesteten Rechten gesichert werden. Er darf niemals in Git landen. Wildcard-Autosigning, ungeprüfte CSRs und das Kopieren fremder Agent-Schlüssel sind verboten.
