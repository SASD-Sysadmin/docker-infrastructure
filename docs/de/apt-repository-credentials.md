# Verschlüsseltes APT-Repository-Kennwort

`role::apt_repository_client` ist der erste konkrete Verbraucher verschlüsselter
Daten. Normale Node-Daten enthalten Host und Login; das Kennwort liegt nur in
der passenden per-Node-`.eyaml`-Datei.

Das Profil erzeugt ausschließlich
`/etc/apt/auth.conf.d/sasd-private-repository.conf` als `root:root` mit Modus
`0600`. URL-Schemata, Pfade, Leerzeichen, Red-Hat-Systeme und lokales nicht
authentifiziertes `puppet apply` werden abgelehnt. Paketquelle und
Signaturschlüssel bleiben getrennte, zu prüfende Änderungen.
