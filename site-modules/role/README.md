# sasd-role

Complete node roles for the SASD Puppet control repository:

- `baseline`
- `managed_agent`
- `server`
- `development`
- `java_development`
- `php_development`
- `polyglot_development`
- `dotnet_development`
- `container_host`
- `puppet_server`

Milestone 10 adds an explicit .NET 10 LTS development role alongside the Java, PHP, and combined roles. Every role
retains platform evidence and fixed profile composition. Eligible central agent
platforms are Debian 12/13, Ubuntu 24.04, AlmaLinux 9, and Rocky Linux 9. The
`puppet_server` role remains limited to Debian 12 and Ubuntu 24.04.
