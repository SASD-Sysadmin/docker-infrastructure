# @summary Assign the minimal standalone SASD software and platform baseline.
class role::baseline {
  contain profile::baseline
  contain profile::platform_state

  Class['profile::baseline']
  -> Class['profile::platform_state']
}
