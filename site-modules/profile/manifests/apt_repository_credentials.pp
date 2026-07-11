# @summary Manage one reviewed APT repository credential from Hiera eyaml.
#
# This profile is intentionally narrow. It does not add an APT source, import a
# signing key, run apt-get, or accept an arbitrary destination path. The secret
# is marked Sensitive so logs and reports redact it; Puppet cached catalogs can
# still contain the clear value and must remain root-only.
#
# @param machine Repository host, optionally followed by a TCP port. Schemes,
#   paths, query strings, and whitespace are rejected.
# @param login Machine-scoped read-only repository account name.
# @param password Encrypted Hiera value converted to Sensitive through
#   lookup_options in data/common.yaml.
class profile::apt_repository_credentials (
  Pattern[/^[A-Za-z0-9](?:[A-Za-z0-9.-]{0,251}[A-Za-z0-9])?(?::[0-9]{1,5})?$/] $machine,
  Pattern[/^[A-Za-z0-9._@+-]{1,128}$/] $login,
  Sensitive[String[1]] $password,
) {
  unless $trusted['authenticated'] == 'remote' {
    fail('profile::apt_repository_credentials requires a centrally authenticated Puppet agent')
  }
  unless $facts['os']['family'] == 'Debian' {
    fail('profile::apt_repository_credentials supports the Debian OS family only')
  }

  file { '/etc/apt/auth.conf.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/apt/auth.conf.d/sasd-private-repository.conf':
    ensure    => file,
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    show_diff => false,
    content   => epp('profile/apt-auth.conf.epp', {
      'machine'  => $machine,
      'login'    => $login,
      'password' => $password,
    }),
    require   => File['/etc/apt/auth.conf.d'],
  }
}
