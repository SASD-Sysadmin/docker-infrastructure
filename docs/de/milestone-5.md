# Milestone 5: Anwendungs-Baselines und Release-Absicherung

Milestone 5 schließt den ersten geplanten Repository-Zyklus ab. Die zentrale Betriebsgrundlage wird um nutzbare Anwendungsinstallationen erweitert, ohne die engen Sicherheitsgrenzen aufzugeben.

## Geliefert

- Profile für Administration, Entwicklung und daemonlose OCI-Werkzeuge;
- explizite Rollen `server`, `development` und `container_host`;
- Anwendungszuordnungsdatei unter `/etc/sasd/applications.d`;
- maschinenlesbarer Rollenkatalog samt Paritätsprüfung;
- deterministische Paketregelprüfung;
- RSpec-Puppet-Tests für jedes neue Profil und jede neue Rolle;
- Container-Workflow für reale Installation und Idempotenz;
- deterministisches Release-Dateimanifest mit Prüfer;
- Freigabe-Gate und Checkliste;
- taggesteuerter Workflow für Release-Artefakte;
- vollständige englische und deutsche Dokumentation.

## Sicherheitsgrenze

Weiterhin erlaubt sind nur `package`, `file`, `service` und der bereits eingeführte exakt freigegebene, nur bei Änderungen ausgeführte systemd-Reload. Die Anwendungsprofile installieren ausschließlich Pakete. Sie ergänzen keine Repositories, starten keine Anwendungsdienste, konfigurieren keine Registries, laden keine Images, erzeugen keine Container oder Benutzer und enthalten keine Secrets.
