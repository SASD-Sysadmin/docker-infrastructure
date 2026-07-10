# @summary Install the reviewed .NET 10 LTS command-line SDK baseline.
#
# Package names are supplied by OS-family Hiera. Ubuntu 24.04 and EL9 use
# their distribution feeds. Debian 12/13 require the separately reviewed
# Microsoft repository bootstrap before this profile is assigned.
#
# The profile does not install workloads, global tools, NuGet sources, project
# templates, IDEs, web services, or user configuration.
#
# @param packages Distribution package names to keep installed.
# @param dotnet_major Expected .NET SDK major recorded as local evidence.
# @param repository_strategy Reviewed source: distribution or microsoft.
# @param manage_packages Allows catalog-only tests to suppress package resources.
class profile::dotnet_sdk (
  Array[String[1]]                        $packages = [],
  Integer[8,99]                           $dotnet_major = 10,
  Enum['distribution', 'microsoft']       $repository_strategy = 'distribution',
  Boolean                                 $manage_packages = true,
) {
  $os_name  = $facts['os']['name']
  $os_major = $facts['os']['release']['major']
  $architecture = $facts['architecture']

  $supported_platform = (
    ($os_name == 'Debian' and $os_major in ['12', '13']) or
    ($os_name == 'Ubuntu' and $os_major == '24.04') or
    ($os_name in ['AlmaLinux', 'Rocky'] and $os_major == '9')
  )
  unless $supported_platform {
    fail("profile::dotnet_sdk does not support ${os_name} ${os_major}")
  }
  unless $architecture in ['amd64', 'x86_64'] {
    fail("profile::dotnet_sdk currently supports x86_64/amd64 only, not ${architecture}")
  }
  if $packages == [] {
    fail("profile::dotnet_sdk requires reviewed package data for ${os_name} ${os_major}")
  }
  if $os_name == 'Debian' and $repository_strategy != 'microsoft' {
    fail('Debian .NET SDK nodes require repository_strategy=microsoft')
  }
  if $os_name != 'Debian' and $repository_strategy != 'distribution' {
    fail("${os_name} .NET SDK nodes must use repository_strategy=distribution")
  }

  contain profile::sdk_status

  if $manage_packages {
    package { $packages:
      ensure => installed,
    }
  }

  file { '/etc/sasd/toolchains.d/dotnet.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/dotnet.conf.epp', {
      'dotnet_major'        => $dotnet_major,
      'repository_strategy' => $repository_strategy,
      'packages'            => $packages,
      'certname'            => $trusted['certname'],
    }),
    require => File['/etc/sasd/toolchains.d'],
  }
}
