# Architektur

## Kontext

Das Repository verwaltet dauerhafte Baselines für Softwareinstallation und
Konfiguration. Es ist kein Werkzeug für Incident Response, Diagnose oder
prozedurale Reparaturen.

## Architektur von Milestone 2

```text
GitHub / lokaler Git-Clone
          |
          | Bootstrap, Validierung, r10k
          v
Standalone-Puppet-Umgebung
  manifests/site.pp
          |
          v
   role::baseline
          |
          v
 profile::baseline
     |          |
  Pakete    /etc/sasd-Markierung
```

Lokal wird ausdrücklich `puppet apply` verwendet, nicht `puppet agent`. No-op
ist Standard. Später werden Puppet Server und r10k-Deployment ergänzt, ohne die
Rollen-/Profilgrenze zu verändern.

## Regeln

`site.pp` und Rollen enthalten keine direkten Workload-Ressourcen. Milestone 2
erlaubt in Profilen nur Pakete und Dateien. Nicht unterstützte Plattformen
brechen bei der Katalogkompilierung ab. Externe Module sind fest versioniert,
Secrets bleiben außerhalb von Git, `--apply` benötigt root und Git-Updates
müssen sauber sowie Fast-Forward sein.
