# @summary Minimal node role used for the workload-free Milestone 1 catalog.
#
# The role composes only `profile::baseline`, which intentionally manages no
# resources. This gives every node a valid, testable classification while keeping
# the repository incapable of changing system state during Milestone 1.
#
# Future application or platform roles should compose focused profiles and must
# not directly declare package, file, service, user, or exec resources.
#
# @api private
class role::baseline {
  include profile::baseline
}
