# @summary Assign a lifecycle-aware .NET 10 LTS development host.
class role::dotnet_development {
  contain profile::baseline
  contain profile::platform_state
  contain profile::administration_tools
  contain profile::development_tools
  contain profile::sdk_status
  contain profile::dotnet_sdk
  contain profile::lifecycle_state
  class { 'profile::application_state':
    role_name        => 'dotnet_development',
    enabled_profiles => ['baseline', 'platform_state', 'administration_tools', 'development_tools', 'sdk_status', 'dotnet_sdk', 'lifecycle_state'],
  }
  contain profile::agent_service

  Class['profile::baseline']
  -> Class['profile::platform_state']
  -> Class['profile::administration_tools']
  -> Class['profile::development_tools']
  -> Class['profile::sdk_status']
  -> Class['profile::dotnet_sdk']
  -> Class['profile::lifecycle_state']
  -> Class['profile::application_state']
  -> Class['profile::agent_service']
}
