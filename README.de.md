# puppet-software-baseline

[English README](README.md) · [Deutscher Dokumentationsindex](docs/de/README.md)

Puppet-Control-Repository zur Installation geprüfter Anwendungsgruppen und zur Sicherstellung konsistenter Paket-, Dienst-, Konfigurations-, Reporting- und Control-Plane-Baselines auf SASD-Systemen.

> **Status:** Milestone 5 ist abgeschlossen (`0.5.0`). Das Repository enthält nun explizite Rollen für Server, Entwicklungsrechner, Container-Hosts, minimale Agents und den Puppet Server, geprüfte Anwendungspaketprofile sowie maschinenlesbare Qualitäts- und Release-Prüfungen.

## Abgrenzung

Puppet beschreibt dauerhaften Sollzustand. Es ersetzt keine Ansible-Runbooks, kein Admin-Toolkit, keine Incident Response und keine einmaligen Reparaturen. Milestone 5 installiert Anwendungen ausschließlich aus den bereits konfigurierten Distributions-Repositories:

- minimale Basispakete;
- Administrationswerkzeuge;
- Kommandozeilen-Entwicklungswerkzeuge;
- daemonlose Podman-/OCI-Werkzeuge;
- konsistenter nativer Puppet-Agent-Dienst;
- Health- und Reporting-Betrieb des Puppet Servers;
- kontrollierte Promotion `main -> test -> production`;
- Release-Manifeste, Freigabeprüfungen, Backups und Rollback-Vorbereitung.

Keine Rolle ergänzt Fremdrepositories, lädt Container-Images, legt Benutzer an, öffnet Firewall-Ports, speichert Secrets oder führt beliebige Shell-Befehle aus.

## Rollen

| Rolle | Zweck | Anwendungsgruppen |
|---|---|---|
| `baseline` | lokale/Standalone-Basis | Basis |
| `managed_agent` | minimal zentral verwalteter Knoten | Basis |
| `server` | allgemeiner Server | Basis, Administration |
| `development` | CLI-Entwicklungsrechner | Basis, Administration, Entwicklung |
| `container_host` | daemonloser OCI-Host | Basis, Administration, Container-Werkzeuge |
| `puppet_server` | Puppet-Control-Plane | Basis, Administration, Serverbetrieb |

Die Klassifizierung bleibt in [`manifests/site.pp`](manifests/site.pp) fest freigegeben. [`config/role-catalog.json`](config/role-catalog.json) bildet denselben Vertrag maschinenlesbar ab.

## Beispiel

```yaml
---
sasd::role: development
```

Die Datei wird als `data/nodes/<vertrauenswürdiger-certname>.yaml` gespeichert, über `main`, `test` und `production` promoviert, mit r10k deployed und zunächst im No-op geprüft.

## Qualitäts- und Release-Prüfungen

```bash
ruby scripts/check_package_policy.rb
python3 scripts/check_role_catalog.py
./scripts/release-readiness.sh --require-branch main
python3 scripts/generate-release-manifest.py
python3 scripts/verify-release-manifest.py dist/release-manifest.json
```

Vollständige Entwicklungsprüfung:

```bash
gem install bundler
./scripts/setup-development.sh
bundle exec rake
```

## Dokumentation

- [Milestone 5](docs/de/milestone-5.md)
- [Anwendungsprofile](docs/de/application-profiles.md)
- [Rollenkatalog](docs/de/role-catalog.md)
- [Compliance und Drift](docs/de/compliance-and-drift.md)
- [Release-Absicherung](docs/de/release-assurance.md)
- [Produktionsbereitschaft](docs/de/production-readiness.md)
- [Milestone-5-Runbook](docs/de/milestone-5-runbook.md)

## Lizenz

Veröffentlicht unter der [MIT-Lizenz](LICENSE).
