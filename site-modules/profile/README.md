# sasd-profile

Implementation profiles for the SASD Puppet control repository. Profiles own
resources; roles compose profiles. Nodes are never classified by dynamically
including profile names from Hiera.

Milestone 10 profiles cover:

- baseline packages and marker;
- non-secret platform evidence;
- administration, general development, and daemonless container tools;
- OpenJDK 17/Maven, distribution PHP, and reviewed .NET 10 LTS SDK packages;
- local non-secret SDK assignment and version evidence;
- lifecycle and application-assignment evidence;
- lifecycle-aware Puppet agent service;
- Puppet Server operational health/reporting support;
- low-cardinality monitoring export for an independent monitoring platform.

Package names are supplied by reviewed OS-family Hiera mappings. Profiles do not
enable EPEL, select EL9 module streams, change
SELinux/firewall policy, or run troubleshooting commands. Debian .NET repository setup is an explicit operator bootstrap outside catalog compilation.
