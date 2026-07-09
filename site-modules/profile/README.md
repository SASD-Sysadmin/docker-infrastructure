# profile module

Implementation profiles for SASD systems.

Milestone 4 provides:

- `profile::baseline`: conservative packages and managed marker;
- `profile::agent_service`: keeps an already enrolled native Puppet agent service running and enabled;
- `profile::server_operations`: installs compact report/health state directories, the health command, and its hardened systemd timer.

Identity-bearing agent settings remain in reviewed bootstrap scripts. Profiles do
not change certnames, CA paths, private keys, DNS identities, or server names.
