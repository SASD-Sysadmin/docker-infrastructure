# Main classification entry point for the Puppet environment.
#
# `site.pp` decides which role a node receives; it does not implement package,
# file, or service policy itself. Milestone 2 intentionally assigns every
# supported local-test node to the same small baseline role. Later server-based
# classification may use trusted certificate names, external classifiers, or a
# reviewed custom role fact without moving implementation resources into this
# file.
node default {
  include role::baseline
}
