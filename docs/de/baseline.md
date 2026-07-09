# Baseline

Milestone 4 behält die konservative Paket-/Datei-Baseline und ergänzt für
zentral verwaltete Knoten einen kontrollierten Dienstzustand. Die Markerdatei
enthält Version `0.4.0`, Plattform, vertrauenswürdigen Certname und Betriebsmodus.

Gemeinsame Pakete sind CA-Zertifikate, curl, Git, jq, Python 3, rsync, tree,
unzip sowie Debian-Familienwerkzeuge für Prozesse und offene Dateien.
`managed_agent` und `puppet_server` halten den Agentdienst nur bei entfernter
Zertifikatsauthentifizierung aktiv.
