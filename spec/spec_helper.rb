# frozen_string_literal: true

require 'rspec-puppet'

CONTROL_REPOSITORY_ROOT = File.expand_path('..', __dir__)

RSpec.configure do |config|
  # Test both first-party site modules and r10k-installed dependencies exactly as
  # the control repository exposes them through environment.conf.
  config.module_path = [
    File.join(CONTROL_REPOSITORY_ROOT, 'site-modules'),
    File.join(CONTROL_REPOSITORY_ROOT, 'modules')
  ].join(File::PATH_SEPARATOR)
  config.manifest_dir = File.join(CONTROL_REPOSITORY_ROOT, 'manifests')
  config.strict_variables = true
end

# Milestone 1 permits only the structural resources emitted by the compiler.
# Future workload stepstones deliberately revise this test boundary.
STRUCTURAL_RESOURCE_TYPES = %w[Class Stage].freeze

def non_structural_resources(catalog)
  catalog.resources.reject { |resource| STRUCTURAL_RESOURCE_TYPES.include?(resource.type) }
end

