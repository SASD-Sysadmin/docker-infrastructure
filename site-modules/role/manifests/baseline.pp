# @summary Assign the minimal SASD software baseline to a node.
#
# Roles describe node purpose and compose profiles. They do not declare package,
# file, or service resources directly. Milestone 2 has one role because the
# first local baseline applies uniformly to every supported test node.
class role::baseline {
  contain profile::baseline
}
