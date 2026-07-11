# Puppet Server readiness

Milestone 3 implements the previously planned server-ready architecture. Before production use, verify:

- final DNS name and certificate alternative names;
- reliable time synchronization;
- protected `production` branch;
- encrypted CA backup and tested restore;
- restricted TCP/8140 access;
- package-source entitlement and update process;
- sufficient JVM memory;
- manual CSR verification procedure;
- one representative agent no-op after every deployment.

PuppetDB, HA, automated deployment hooks, and policy autosigning are not readiness requirements for this small first server but remain future design decisions.
