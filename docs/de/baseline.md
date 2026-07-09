# Baseline

Der Anwendungs-Workload bleibt in Milestone 3 absichtlich klein: konservative Administrationspakete und `/etc/sasd/puppet-baseline.conf`. Die Markerdatei enthält Version `0.3.0`, Betriebssystem, vertrauenswürdigen Certname und den Modus `local-puppet-apply` oder `puppet-server`.

Der Scope-Check erlaubt weiterhin ausschließlich `package` und `file`. Serverinstallation und Zertifikatsaktionen sind explizite Control-Plane-Skripte und keine versteckten Katalogressourcen.
