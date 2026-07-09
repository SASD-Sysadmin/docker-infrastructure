# Reference

## `profile::baseline`

Installs the package baseline and manages the SASD marker on Debian 12,
Debian 13, and Ubuntu 24.04 agents. Hiera supplies normal parameters. The marker
contains the baseline version, platform, trusted certname, and management mode.

See the Puppet Strings comments in `manifests/baseline.pp` for the complete
parameter contract and security boundary.
