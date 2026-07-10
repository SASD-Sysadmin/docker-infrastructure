# .NET 10 LTS SDK

`profile::dotnet_sdk` installs `dotnet-sdk-10.0` and writes `/etc/sasd/toolchains.d/dotnet.conf`. .NET 10 is the selected LTS baseline and is expected to remain supported through 14 November 2028.

## Repository strategies

Debian requires the official Microsoft repository configuration package. Ubuntu 24.04 and EL9 use distribution feeds. The Puppet profile validates this strategy through Hiera but does not mutate package repositories.

## Local validation

```bash
sudo sasd-sdk-status
sudo sasd-sdk-status --json
dotnet --info
dotnet --list-sdks
```

The status helper requires a major version of 10.

## Not managed

- `dotnet workload`;
- global tools;
- NuGet credentials or package sources;
- `global.json`;
- IDEs and extensions;
- project restore/build;
- ASP.NET services or reverse proxies.
