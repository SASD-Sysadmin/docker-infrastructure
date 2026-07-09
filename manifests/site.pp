# Main classification entry point for this Puppet environment.
#
# Classification is intentionally small and auditable. Hiera supplies the
# logical role name through `sasd::role`; this manifest maps only explicitly
# approved values to concrete role classes. It does not dynamically include an
# arbitrary class name from data, which prevents an accidental or malicious
# Hiera value from expanding the catalog beyond the reviewed role allowlist.
#
# Milestone 3 exposes only `baseline`. Future application stepstones add a new
# case branch, tests, documentation, and Hiera data in the same change.
$assigned_role = lookup('sasd::role', String[1], 'first', 'baseline')

case $assigned_role {
  'baseline': {
    include role::baseline
  }
  default: {
    fail("Unsupported sasd::role '${assigned_role}'. Allowed roles in Milestone 3: baseline")
  }
}
