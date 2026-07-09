# Supported platforms

## Puppet Server

- Debian 12 amd64;
- Ubuntu 24.04 LTS amd64.

Debian 13 is intentionally not accepted as a server in Milestone 3. The official agent and server platform matrices are not identical, and server support/package availability must be verified separately.

## Managed agents

- Debian 12;
- Debian 13;
- Ubuntu 24.04 LTS.

The manifest metadata accepts Puppet `>= 7.23.0 < 9.0.0`. CI covers Puppet 7.23 and 8.10. Distribution package versions vary by OS; current Puppet Core packages require authenticated repository access.

## Architecture limitations

Bootstrap scripts target Apt/systemd hosts. Other architectures or operating-system families require a separate tested implementation rather than bypassing the platform check.
