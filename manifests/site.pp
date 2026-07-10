# Main classification entry point for this Puppet environment.
#
# Hiera supplies the reviewed role through `sasd::role` and the lifecycle state
# through `sasd::lifecycle_state`. Both values are allowlisted below. Never
# replace this dispatcher with a dynamic `include $value`: data must not be able
# to select arbitrary Puppet classes.
#
# Lifecycle contract:
# - active: compile and enforce the assigned role normally;
# - maintenance: compile the same role, write maintenance evidence, and stop the
#   periodic Puppet agent after the current run completes;
# - retired: reject catalog compilation until the node is decommissioned and its
#   certificate and node data are removed through the documented workflow.
$assigned_role = lookup('sasd::role', String[1], 'first', 'baseline')
$lifecycle_state = lookup('sasd::lifecycle_state', String[1], 'first', 'active')

unless $lifecycle_state in ['active', 'maintenance', 'retired'] {
  fail("Unsupported sasd::lifecycle_state '${lifecycle_state}'. Allowed values: active, maintenance, retired")
}

if $lifecycle_state == 'retired' {
  fail("Node '${trusted['certname']}' is marked retired. No catalog is compiled; complete the decommission runbook.")
}

case $assigned_role {
  'baseline': {
    if $lifecycle_state != 'active' {
      fail('The standalone baseline role supports only lifecycle_state=active')
    }
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
  'java_development': {
    include role::java_development
  }
  'php_development': {
    include role::php_development
  }
  'polyglot_development': {
    include role::polyglot_development
  }
  'dotnet_development': {
    include role::dotnet_development
  }
  default: {
    fail("Unsupported sasd::role '${assigned_role}'. Allowed roles: baseline, managed_agent, server, development, container_host, puppet_server, java_development, php_development, polyglot_development, dotnet_development")
  }
}
