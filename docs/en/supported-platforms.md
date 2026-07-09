# Supported platforms

| OS | Release | Local package source | Tested Puppet line |
|---|---|---|---|
| Debian | 12 Bookworm | Debian repositories | 7.23 |
| Debian | 13 Trixie | Debian repositories | 8.10 |
| Ubuntu | 24.04 LTS Noble | Ubuntu Universe | 8.4; code also tested with 8.10 |

The bootstrap checks `/etc/os-release`; the profile checks Puppet facts. Both
checks are required because bootstrap support and catalog support are separate
trust boundaries.

Architectures are not hard-coded. Actual package availability remains the
responsibility of the selected distribution repositories. Test first on the
same architecture used in production.
