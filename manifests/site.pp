# Main classification entry point for this Puppet environment.
#
# Hiera supplies the logical role through `sasd::role`. Only the reviewed values
# below can become classes. Never replace this case statement with a dynamic
# `include $assigned_role`: data must not be able to select arbitrary code.
#
# Milestone 5 roles:
# - baseline: small standalone/local package and marker baseline;
# - managed_agent: central baseline plus native Puppet agent service;
# - server: central server utilities and agent service;
# - development: central server utilities, development tools, and agent service;
# - container_host: central server utilities, rootless-container tools, and agent service;
# - puppet_server: central control-plane operations and administration tools.
$assigned_role = lookup('sasd::role', String[1], 'first', 'baseline')

case $assigned_role {
  'baseline': {
    include role::baseline
  }
  'managed_agent': {
    include role::managed_agent
  }
  'server': {
    include role::server
  }
  'development': {
    include role::development
  }
  'container_host': {
    include role::container_host
  }
  'puppet_server': {
    include role::puppet_server
  }
  default: {
    fail("Unsupported sasd::role '${assigned_role}'. Allowed roles in Milestone 5: baseline, managed_agent, server, development, container_host, puppet_server")
  }
}
