# frozen_string_literal: true

require 'rspec-puppet'

CONTROL_REPOSITORY_ROOT = File.expand_path('..', __dir__)

RSpec.configure do |config|
  config.module_path = [
    File.join(CONTROL_REPOSITORY_ROOT, 'site-modules'),
    File.join(CONTROL_REPOSITORY_ROOT, 'modules')
  ].join(File::PATH_SEPARATOR)
  config.manifest_dir = File.join(CONTROL_REPOSITORY_ROOT, 'manifests')
  config.hiera_config = File.join(CONTROL_REPOSITORY_ROOT, 'hiera.yaml')
  config.strict_variables = true
end

SUPPORTED_FACTS = {
  debian12: {
    os: { 'family' => 'Debian', 'name' => 'Debian', 'release' => { 'major' => '12' } },
    networking: { 'fqdn' => 'debian12.example.test' }
  },
  debian13: {
    os: { 'family' => 'Debian', 'name' => 'Debian', 'release' => { 'major' => '13' } },
    networking: { 'fqdn' => 'debian13.example.test' }
  },
  ubuntu2404: {
    os: { 'family' => 'Debian', 'name' => 'Ubuntu', 'release' => { 'major' => '24.04' } },
    networking: { 'fqdn' => 'ubuntu2404.example.test' }
  }
}.freeze

EXPECTED_COMMON_PACKAGES = %w[ca-certificates curl git jq python3 rsync tree unzip lsof procps].freeze
