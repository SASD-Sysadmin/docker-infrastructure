# SELinux and firewall boundary

Milestone 7 detects and supports EL9 as a Puppet agent platform but does not weaken host security controls.

The repository does not:

- call `setenforce`, `setsebool`, `semanage`, or `firewall-cmd`;
- install custom SELinux modules;
- set SELinux permissive or disabled;
- open TCP/8140 or any other port;
- enable EPEL;
- overwrite local security policy.

Puppet must operate under the host's existing SELinux and network policy. If a site-specific policy blocks required behavior, investigate the denial, document the exact requirement, and create a separate reviewed change with tests and rollback. Do not add blanket exceptions to this software baseline.
