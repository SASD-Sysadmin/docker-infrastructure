# sasd-profile

Implementation profiles for the SASD Puppet control repository. Profiles own
resources; roles compose profiles. Nodes are never classified by dynamically
including profile names from Hiera.

Milestone 9 profiles cover:

- baseline packages and marker;
- non-secret platform evidence;
- administration, general development, and daemonless container tools;
- OpenJDK 17/Maven and distribution PHP SDK packages;
- local non-secret SDK assignment and version evidence;
- lifecycle and application-assignment evidence;
- lifecycle-aware Puppet agent service;
- Puppet Server operational health/reporting support;
- low-cardinality monitoring export for an independent monitoring platform.

Package names are supplied by reviewed OS-family Hiera mappings. Profiles do not
enable EPEL or third-party SDK repositories, select EL9 module streams, change
SELinux/firewall policy, or run troubleshooting commands.
