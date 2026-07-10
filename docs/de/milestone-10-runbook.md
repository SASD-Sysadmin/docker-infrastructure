# Milestone-10-Runbook

## 1. Repository prüfen

```bash
./scripts/validate.sh
python3 scripts/check_dotnet_repository_catalog.py
tests/smoke/dotnet-profile.sh
tests/smoke/dotnet-repository.sh
```

## 2. Debian-Paketquelle vorbereiten

Auf Ubuntu 24.04, AlmaLinux 9 und Rocky Linux 9 entfällt dieser Schritt.

```bash
./scripts/setup-dotnet-repository.sh
sudo ./scripts/setup-dotnet-repository.sh --apply
apt-cache policy dotnet-sdk-10.0
```

## 3. Knotendaten

```yaml
---
sasd::role: dotnet_development
sasd::lifecycle_state: active
sasd::owner: development
sasd::description: .NET-10-LTS-Entwicklungsrechner
```

## 4. Promotion und Test

`main -> test` promovieren, Test-Environment deployen, `puppet agent -t --noop` ausführen, Paketquelle und SDK-Status kontrollieren und anschließend `test -> production` promovieren.

## 5. Abnahme

```bash
dotnet --version
dotnet --list-sdks
sudo sasd-sdk-status --json
```

Erwartete Hauptversion: 10.
