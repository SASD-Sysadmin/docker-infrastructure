# Operating-system data

The active Hiera order is exact OS release, OS name, OS family, then common data.
Milestone 3 supports these managed-agent platforms:

- Debian 12;
- Debian 13;
- Ubuntu 24.04 LTS.

The Puppet Server bootstrap is intentionally narrower and supports Debian 12
and Ubuntu 24.04 LTS only. Keep package-name differences in the narrowest
suitable layer. Do not place secrets, host identities, or procedural repair
logic in these files.
