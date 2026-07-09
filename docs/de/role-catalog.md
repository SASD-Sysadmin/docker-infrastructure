# Rollenkatalog

`config/role-catalog.json` ist der maschinenlesbare Rollenvertrag. Er wird ausdrücklich nicht für dynamische Klasseneinbindung verwendet. `manifests/site.pp` bleibt die Sicherheitsgrenze und ordnet jeden freigegebenen Wert einer konkreten Rollenklasse zu.

## Rollen

- `baseline`: lokales/Standalone-Minimum ohne Agentdienst;
- `managed_agent`: minimaler signierter zentraler Agent;
- `server`: Basis plus Administrationswerkzeuge;
- `development`: Serverwerkzeuge plus Entwicklungswerkzeuge;
- `container_host`: Serverwerkzeuge plus daemonlose OCI-Werkzeuge;
- `puppet_server`: Administration, Agentdienst, Health und Reporting.

Alle zentralen Rollen benötigen einen remote authentifizierten Katalog. Enrollment und Zertifikatsfreigabe müssen daher vor dem Rollenwechsel abgeschlossen sein.

Prüfung:

```bash
python3 scripts/check_role_catalog.py
```
