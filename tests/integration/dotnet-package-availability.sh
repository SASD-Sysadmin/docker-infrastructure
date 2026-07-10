#!/usr/bin/env bash
# Install .NET 10 SDK in a disposable supported x86_64 container.
set -euo pipefail
image="${1:?Usage: dotnet-package-availability.sh IMAGE PLATFORM}"
platform="${2:?Usage: dotnet-package-availability.sh IMAGE PLATFORM}"
command -v docker >/dev/null 2>&1 || { echo 'ERROR: docker not found' >&2; exit 127; }
case "${platform}" in
  debian12) command='apt-get update; apt-get install -y ca-certificates curl; curl -fsSL --proto "=https" --tlsv1.2 https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -o /tmp/ms.deb; test "$(dpkg-deb --field /tmp/ms.deb Package)" = packages-microsoft-prod; dpkg -i /tmp/ms.deb; apt-get update; apt-get install -y dotnet-sdk-10.0; dotnet --version | grep -E "^10\\."' ;;
  debian13) command='apt-get update; apt-get install -y ca-certificates curl; curl -fsSL --proto "=https" --tlsv1.2 https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb -o /tmp/ms.deb; test "$(dpkg-deb --field /tmp/ms.deb Package)" = packages-microsoft-prod; dpkg -i /tmp/ms.deb; apt-get update; apt-get install -y dotnet-sdk-10.0; dotnet --version | grep -E "^10\\."' ;;
  ubuntu2404) command='apt-get update; apt-get install -y dotnet-sdk-10.0; dotnet --version | grep -E "^10\\."' ;;
  rocky9|almalinux9) command='dnf --assumeyes install dotnet-sdk-10.0; dotnet --version | grep -E "^10\\."' ;;
  *) echo 'unsupported platform' >&2; exit 64;;
esac
docker run --rm --platform linux/amd64 "${image}" bash -ceu "${command}"
