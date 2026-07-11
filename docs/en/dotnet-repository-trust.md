# .NET repository trust

## Debian 12 and 13

Run the guarded setup before assigning the role:

```bash
./scripts/setup-dotnet-repository.sh --os-release-file /etc/os-release
sudo ./scripts/setup-dotnet-repository.sh --apply
```

The script accepts only the official HTTPS URL, downloads to a temporary file, checks that the Debian package name is `packages-microsoft-prod`, installs it, refreshes APT metadata, and confirms that `dotnet-sdk-10.0` is visible. It does not use `apt-key`, shell pipelines, or unreviewed mirrors. An operator can additionally provide `--expected-sha256 HEX` to pin the downloaded configuration package for a controlled change window.

## Ubuntu and EL9

No external repository is added. The distribution feed is the reviewed source.

## Review points

- inspect `apt-cache policy dotnet-sdk-10.0` or `dnf info dotnet-sdk-10.0`;
- ensure no duplicate Microsoft/Ubuntu feeds are mixed;
- promote the node data through `main -> test -> production`;
- validate with a no-op before applying.
