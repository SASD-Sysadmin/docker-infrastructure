# Vertrauen der .NET-Paketquelle

## Debian 12 und 13

Vor Zuweisung der Rolle wird das abgesicherte Setup ausgeführt:

```bash
./scripts/setup-dotnet-repository.sh --os-release-file /etc/os-release
sudo ./scripts/setup-dotnet-repository.sh --apply
```

Das Skript akzeptiert nur die offizielle HTTPS-Adresse, lädt in eine temporäre Datei, prüft den Debian-Paketnamen `packages-microsoft-prod`, installiert das Paket, aktualisiert APT und prüft die Sichtbarkeit von `dotnet-sdk-10.0`. `apt-key`, Shell-Pipelines und nicht geprüfte Spiegel werden nicht verwendet. Optional kann mit `--expected-sha256 HEX` eine im Änderungsfenster geprüfte Prüfsumme fest vorgegeben werden.

## Ubuntu und EL9

Es wird kein Fremdrepository hinzugefügt. Der Distributionsfeed ist die geprüfte Quelle.
