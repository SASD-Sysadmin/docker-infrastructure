# @summary Assign a lifecycle-aware PHP command-line development host.
class role::php_development {
  contain profile::baseline
  contain profile::platform_state
  contain profile::administration_tools
  contain profile::development_tools
  contain profile::sdk_status
  contain profile::php_sdk
  contain profile::lifecycle_state
  class { 'profile::application_state':
    role_name        => 'php_development',
    enabled_profiles => ['baseline', 'platform_state', 'administration_tools', 'development_tools', 'sdk_status', 'php_sdk', 'lifecycle_state'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::platform_state']
  -> Class['profile::administration_tools']
  -> Class['profile::development_tools']
  -> Class['profile::sdk_status']
  -> Class['profile::php_sdk']
  -> Class['profile::lifecycle_state']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
