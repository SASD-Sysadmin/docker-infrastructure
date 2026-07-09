# profile module

Implementation profiles for SASD systems.

Milestone 3 provides `profile::baseline`, which:

- rejects unsupported agent platforms during catalog compilation;
- installs a small administration package set supplied by Hiera;
- manages `/etc/sasd/puppet-baseline.conf`;
- records whether the catalog came from local `puppet apply` or Puppet Server;
- deliberately avoids services, users, repositories, firewall state, and
  arbitrary `exec` resources.

Control-plane bootstrap scripts install Puppet Server and enroll agents; those
operations are intentionally not hidden inside an application profile.
