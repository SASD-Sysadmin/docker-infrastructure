# @summary Assign the minimal SASD software baseline to a node.
#
# Roles describe node purpose and compose profiles. They do not declare package,
# file, or service resources directly. Milestone 3 still has one role because application-specific workloads are
# deliberately deferred until later stepstones.
class role::baseline {
  contain profile::baseline
}
