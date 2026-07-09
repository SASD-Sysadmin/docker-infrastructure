# @summary Main classification manifest for the SASD Puppet environment.
#
# This file is evaluated by Puppet Server when it compiles an agent catalog and
# by `puppet apply` during local validation. Milestone 1 deliberately assigns
# every node to a workload-free baseline role. The role/profile chain therefore
# compiles and can be unit-tested without managing any package, file, service,
# user, repository, or command on the target system.
#
# Productive node classification will be introduced in a later stepstone. Until
# then, do not add host-specific conditionals or application resources here.
node default {
  include role::baseline
}
