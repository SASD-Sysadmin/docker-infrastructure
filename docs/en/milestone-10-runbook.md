# Milestone 10 runbook

## 1. Validate the repository

```bash
./scripts/validate.sh
python3 scripts/check_dotnet_repository_catalog.py
tests/smoke/dotnet-profile.sh
tests/smoke/dotnet-repository.sh
```

## 2. Prepare Debian repository trust

Skip this step on Ubuntu 24.04, AlmaLinux 9, and Rocky Linux 9.

```bash
./scripts/setup-dotnet-repository.sh
sudo ./scripts/setup-dotnet-repository.sh --apply
apt-cache policy dotnet-sdk-10.0
```

## 3. Register node data

```yaml
---
sasd::role: dotnet_development
sasd::lifecycle_state: active
sasd::owner: development
sasd::description: .NET 10 LTS development host
```

## 4. Promote and test

Promote `main -> test`, deploy test, run `puppet agent -t --noop`, inspect package source and SDK status, then promote `test -> production`.

## 5. Acceptance

```bash
dotnet --version
dotnet --list-sdks
sudo sasd-sdk-status --json
```

Expected major: 10.

## 6. Removal

Change the role through the normal promotion path. Removing the Microsoft Debian repository is a separate operator decision because other Microsoft packages may depend on it.
