# @summary Assign a lifecycle-aware Java development host with OpenJDK 17 and Maven.
class role::java_development {
  contain profile::baseline
  contain profile::platform_state
  contain profile::administration_tools
  contain profile::development_tools
  contain profile::sdk_status
  contain profile::java_sdk
  contain profile::lifecycle_state
  class { 'profile::application_state':
    role_name        => 'java_development',
    enabled_profiles => ['baseline', 'platform_state', 'administration_tools', 'development_tools', 'sdk_status', 'java_sdk', 'lifecycle_state'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::platform_state']
  -> Class['profile::administration_tools']
  -> Class['profile::development_tools']
  -> Class['profile::sdk_status']
  -> Class['profile::java_sdk']
  -> Class['profile::lifecycle_state']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
