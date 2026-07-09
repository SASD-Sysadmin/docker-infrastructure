# frozen_string_literal: true
require 'rspec-puppet'
CONTROL_REPOSITORY_ROOT = File.expand_path('..', __dir__)
RSpec.configure do |config|
  config.module_path = [File.join(CONTROL_REPOSITORY_ROOT,'site-modules'),File.join(CONTROL_REPOSITORY_ROOT,'modules')].join(File::PATH_SEPARATOR)
  config.manifest_dir = File.join(CONTROL_REPOSITORY_ROOT,'manifests')
  config.hiera_config = File.join(CONTROL_REPOSITORY_ROOT,'hiera.yaml')
  config.strict_variables = true
end
SUPPORTED_FACTS = {
  debian12:{os:{'family'=>'Debian','name'=>'Debian','release'=>{'major'=>'12'},'architecture'=>'x86_64'},architecture:'x86_64',networking:{'fqdn'=>'debian12.example.test'}},
  debian13:{os:{'family'=>'Debian','name'=>'Debian','release'=>{'major'=>'13'},'architecture'=>'x86_64'},architecture:'x86_64',networking:{'fqdn'=>'debian13.example.test'}},
  ubuntu2404:{os:{'family'=>'Debian','name'=>'Ubuntu','release'=>{'major'=>'24.04'},'architecture'=>'x86_64'},architecture:'x86_64',networking:{'fqdn'=>'ubuntu2404.example.test'}},
  almalinux9:{os:{'family'=>'RedHat','name'=>'AlmaLinux','release'=>{'major'=>'9'},'architecture'=>'x86_64'},architecture:'x86_64',networking:{'fqdn'=>'almalinux9.example.test'}},
  rocky9:{os:{'family'=>'RedHat','name'=>'Rocky','release'=>{'major'=>'9'},'architecture'=>'x86_64'},architecture:'x86_64',networking:{'fqdn'=>'rocky9.example.test'}}
}.freeze
PACKAGE_EXPECTATIONS = {
  Debian:{
    baseline:%w[ca-certificates curl git jq lsof procps python3 rsync tree unzip],
    administration_tools:%w[acl attr bash-completion dnsutils file htop less nano netcat-openbsd psmisc sudo tcpdump vim zip],
    development_tools:%w[build-essential gdb pkg-config python3-dev python3-pip python3-venv shellcheck],
    container_tools:%w[buildah fuse-overlayfs podman skopeo slirp4netns uidmap]
  },
  RedHat:{
    baseline:%w[ca-certificates curl git jq lsof procps-ng python3 rsync tar tree unzip],
    administration_tools:%w[acl attr bash-completion bind-utils file less nano nmap-ncat psmisc sudo tcpdump vim-enhanced zip],
    development_tools:%w[gcc gcc-c++ gdb make pkgconf-pkg-config python3-devel python3-pip],
    container_tools:%w[buildah fuse-overlayfs podman shadow-utils skopeo slirp4netns]
  }
}.freeze
