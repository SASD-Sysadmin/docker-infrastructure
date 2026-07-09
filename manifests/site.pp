# Main classification entry point for this Puppet environment.
#
# Hiera supplies the logical role name through `sasd::role`. This manifest maps
# only reviewed values to concrete role classes. It never dynamically includes
# an arbitrary class name from data.
#
# Milestone 4 roles:
# - baseline: standalone/local package and marker baseline;
# - managed_agent: centrally managed baseline plus Puppet agent service state;
# - puppet_server: centrally managed server plus operational health/reporting.
$assigned_role = lookup('sasd::role', String[1], 'first', 'baseline')

case $assigned_role {
  'baseline': {
    include role::baseline
  }
  'managed_agent': {
    include role::managed_agent
  }
  'puppet_server': {
    include role::puppet_server
  }
  default: {
    fail("Unsupported sasd::role '${assigned_role}'. Allowed roles in Milestone 4: baseline, managed_agent, puppet_server")
  }
}
