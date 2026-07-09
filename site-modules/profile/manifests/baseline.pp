# @summary Workload-free foundation profile used to verify the control repository.
#
# This profile is intentionally empty in Milestone 1. It proves that the
# role/profile chain, module path, main manifest, RSpec-Puppet test harness, and
# local catalog compilation are operational before any real system state is
# declared.
#
# Future baseline components should normally be implemented as separate focused
# profiles and composed by `role::baseline`; this class must not become an
# unstructured collection of unrelated resources.
#
# @api private
class profile::baseline {
}
