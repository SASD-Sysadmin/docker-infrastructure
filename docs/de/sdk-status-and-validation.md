# SDK-Status und Validierung

Puppet schreibt Erwartungsdateien unter `/etc/sasd/toolchains.d`. Der rein lesende Befehl `/usr/local/sbin/sasd-sdk-status` vergleicht diese Vorgaben mit den auf dem Host verfügbaren Befehlen.

```bash
sudo sasd-sdk-status
sudo sasd-sdk-status --json
```

Fehlt ein erwarteter Befehl, liefert das Werkzeug Exitcode `3`. Es fragt keine Internet-Registries ab und untersucht weder Projektquelltexte noch Lock-Dateien.

```bash
python3 scripts/check_sdk_catalog.py
python3 scripts/check_milestone9_scope.py
python3 scripts/check_milestone10_scope.py
python3 scripts/check_dotnet_repository_catalog.py
tests/smoke/sdk-profiles.sh
tests/smoke/dotnet-profile.sh
tests/smoke/sdk-status.sh
```
