# Rollenkatalog

`config/role-catalog.json` ist der maschinenlesbare Rollenvertrag. Er wird nicht
für dynamische Klasseneinbindung verwendet. `manifests/site.pp` bleibt die
Sicherheitsgrenze und ordnet jeden freigegebenen Wert einer konkreten
Rollenklasse zu.

## Rollen

- `baseline`: lokales/Standalone-Minimum ohne Agentdienst;
- `managed_agent`: minimaler signierter zentraler Agent;
- `server`: Basis plus Administrationswerkzeuge;
- `development`: Serverwerkzeuge plus allgemeine Entwicklungswerkzeuge;
- `java_development`: Entwicklungsrolle plus OpenJDK 17 und Maven;
- `php_development`: Entwicklungsrolle plus PHP-SDK der Distribution;
- `polyglot_development`: Entwicklungsrolle plus beide geprüften SDK-Profile;
- `container_host`: Serverwerkzeuge plus daemonlose OCI-Werkzeuge;
- `puppet_server`: Administration, Agentdienst, Health und Reporting.

Alle zentralen Rollen benötigen einen remote authentifizierten Katalog.
Enrollment und Zertifikatsfreigabe müssen vor dem Rollenwechsel abgeschlossen
sein. Sprach-SDK-Rollen besitzen eine feste Profilzusammensetzung. Hiera liefert
geprüfte Paketnamen, aber keine beliebigen Klassennamen, Repositories,
Installationsprogramme oder Kommandos.

Prüfung:

```bash
python3 scripts/check_role_catalog.py
python3 scripts/check_sdk_catalog.py
```

## `dotnet_development`

Zentrale x86_64-Entwicklungsrolle aus allgemeiner Entwicklungsbaseline und `profile::dotnet_sdk`.
