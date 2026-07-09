# profile module

Implementation profiles for SASD systems.

Milestone 2 provides `profile::baseline`, which:

- rejects unsupported platforms during catalog compilation;
- installs a small administration package set supplied by Hiera;
- manages `/etc/sasd/puppet-baseline.conf` from an EPP template;
- deliberately avoids services, users, repositories, firewall state, and
  arbitrary `exec` resources.

Roles may include or contain this profile. Node classification and application
composition must not be implemented inside it.
