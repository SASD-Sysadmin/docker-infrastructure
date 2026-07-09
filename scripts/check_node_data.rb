#!/usr/bin/env ruby
# Validate active and retired node records without third-party gems.
require 'json'
require 'psych'
require 'time'

root = File.expand_path('..', __dir__)
contract = JSON.parse(File.read(File.join(root, 'config/node-data-contract.json')))
roles = contract.fetch('allowed_roles')
states = contract.fetch('allowed_lifecycle_states')
required = contract.fetch('required_keys')
maintenance_required = contract.fetch('maintenance_required_keys')
cert_pattern = Regexp.new(contract.fetch('certname_pattern'))
time_pattern = Regexp.new(contract.fetch('utc_timestamp_pattern'))
failures = []
counts = Hash.new(0)

validate = lambda do |path, retired_directory|
  rel = path.delete_prefix(root + '/')
  certname = File.basename(path, '.yaml')
  failures << "#{rel}: invalid certname filename" unless certname.match?(cert_pattern)
  begin
    data = Psych.safe_load_file(path, permitted_classes: [], permitted_symbols: [], aliases: false)
  rescue StandardError => e
    failures << "#{rel}: YAML error: #{e.message}"
    next
  end
  unless data.is_a?(Hash)
    failures << "#{rel}: top-level value must be a mapping"
    next
  end
  required.each { |key| failures << "#{rel}: missing non-empty #{key}" unless data[key].is_a?(String) && !data[key].strip.empty? }
  role = data['sasd::role']
  state = data['sasd::lifecycle_state']
  failures << "#{rel}: unsupported role #{role.inspect}" unless roles.include?(role)
  failures << "#{rel}: unsupported lifecycle #{state.inspect}" unless states.include?(state)
  failures << "#{rel}: retired directory requires lifecycle retired" if retired_directory && state != 'retired'
  if retired_directory
    stamp = data['sasd::decommissioned_at']
    failures << "#{rel}: retired record requires sasd::decommissioned_at" unless stamp.is_a?(String) && stamp.match?(time_pattern)
    begin Time.iso8601(stamp) if stamp.is_a?(String); rescue ArgumentError; failures << "#{rel}: invalid decommissioned_at timestamp"; end
  end
  failures << "#{rel}: active inventory must not contain decommissioned_at" if !retired_directory && data.key?('sasd::decommissioned_at')
  if state == 'maintenance'
    maintenance_required.each { |key| failures << "#{rel}: maintenance requires non-empty #{key}" unless data[key].is_a?(String) && !data[key].strip.empty? }
    expires = data['sasd::lifecycle_expires_at']
    if expires.is_a?(String) && !expires.empty?
      failures << "#{rel}: expiry must be UTC YYYY-MM-DDTHH:MM:SSZ" unless expires.match?(time_pattern)
      begin Time.iso8601(expires); rescue ArgumentError; failures << "#{rel}: invalid expiry timestamp"; end
    end
  elsif state == 'active'
    maintenance_required.each { |key| failures << "#{rel}: active node must not retain #{key}" if data.key?(key) && !data[key].to_s.empty? }
  elsif state == 'retired'
    failures << "#{rel}: retired node requires sasd::lifecycle_reason" unless data['sasd::lifecycle_reason'].is_a?(String) && !data['sasd::lifecycle_reason'].empty?
    failures << "#{rel}: retired node requires sasd::lifecycle_ticket" unless data['sasd::lifecycle_ticket'].is_a?(String) && !data['sasd::lifecycle_ticket'].empty?
  end
  counts[state] += 1 if states.include?(state)
end

Dir.glob(File.join(root, 'data/nodes/*.yaml')).sort.each { |path| validate.call(path, false) }
Dir.glob(File.join(root, 'data/retired/*.yaml')).sort.each { |path| validate.call(path, true) }

if failures.empty?
  puts "Node data contract passed: #{counts.sort.map { |k,v| "#{k}=#{v}" }.join(', ')}."
else
  warn failures.map { |x| "ERROR: #{x}" }.join("\n")
  exit 1
end
