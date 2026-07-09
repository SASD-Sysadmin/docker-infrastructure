#!/usr/bin/env ruby
# Validate the package-group policy without requiring Puppet or third-party gems.
require 'psych'
require 'set'
root = File.expand_path('..', __dir__)
data = Psych.safe_load_file(File.join(root, 'data/common.yaml'), permitted_classes: [], permitted_symbols: [], aliases: false)
keys = %w[
  profile::baseline::packages
  profile::administration_tools::packages
  profile::development_tools::packages
  profile::container_tools::packages
]
pattern = /\A[a-z0-9][a-z0-9+.-]*\z/
failures = []
seen = {}
keys.each do |key|
  value = data[key]
  failures << "#{key} must be a non-empty array" unless value.is_a?(Array) && !value.empty?
  next unless value.is_a?(Array)
  failures << "#{key} must be sorted" unless value == value.sort
  failures << "#{key} contains duplicates" unless value.uniq == value
  value.each do |package|
    failures << "#{key}: invalid package name #{package.inspect}" unless package.is_a?(String) && package.match?(pattern)
    if seen.key?(package)
      failures << "package #{package} appears in both #{seen[package]} and #{key}"
    else
      seen[package] = key
    end
  end
end
if failures.empty?
  puts "Package policy passed for #{keys.length} groups and #{seen.length} unique packages."
else
  warn failures.map { |x| "ERROR: #{x}" }.join("\n")
  exit 1
end
