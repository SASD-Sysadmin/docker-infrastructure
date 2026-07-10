#!/usr/bin/env ruby
# Validate each OS-family package mapping without Puppet or third-party gems.
require 'psych'
root = File.expand_path('..', __dir__)
files = %w[data/os/family/Debian.yaml data/os/family/RedHat.yaml]
keys = %w[
  profile::baseline::packages
  profile::administration_tools::packages
  profile::development_tools::packages
  profile::container_tools::packages
  profile::java_sdk::packages
  profile::php_sdk::packages
  profile::dotnet_sdk::packages
]
pattern = /\A[a-zA-Z0-9][a-zA-Z0-9+._-]*\z/
failures=[]; totals={}
files.each do |rel|
  data=Psych.safe_load_file(File.join(root,rel),permitted_classes:[],permitted_symbols:[],aliases:false)
  seen={}
  keys.each do |key|
    value=data[key]
    failures << "#{rel}: #{key} must be a non-empty array" unless value.is_a?(Array) && !value.empty?
    next unless value.is_a?(Array)
    failures << "#{rel}: #{key} must be sorted" unless value == value.sort
    failures << "#{rel}: #{key} contains duplicates" unless value.uniq == value
    value.each do |package|
      failures << "#{rel}: #{key}: invalid package name #{package.inspect}" unless package.is_a?(String) && package.match?(pattern)
      failures << "#{rel}: package #{package} appears in both #{seen[package]} and #{key}" if seen.key?(package)
      seen[package] ||= key
    end
  end
  totals[rel]=seen.length
end
if failures.empty?
  puts "Package policy passed: " + totals.map { |k,v| "#{k}=#{v}" }.join(', ')
else
  warn failures.map { |x| "ERROR: #{x}" }.join("\n"); exit 1
end
