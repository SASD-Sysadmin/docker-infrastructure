#!/usr/bin/env ruby
# Render reviewed node data as a human-readable or machine-readable inventory.
require 'csv'
require 'json'
require 'optparse'
require 'psych'
require 'time'

root = File.expand_path('..', __dir__)
options = { format: 'table', include_retired: false }
OptionParser.new do |o|
  o.banner = 'Usage: node-inventory.rb [--format table|json|csv] [--include-retired]'
  o.on('--format FORMAT') { |v| options[:format] = v }
  o.on('--include-retired') { options[:include_retired] = true }
end.parse!
abort('ERROR: format must be table, json, or csv') unless %w[table json csv].include?(options[:format])

rows = []
paths = Dir.glob(File.join(root, 'data/nodes/*.yaml'))
paths += Dir.glob(File.join(root, 'data/retired/*.yaml')) if options[:include_retired]
paths.sort.each do |path|
  data = Psych.safe_load_file(path, permitted_classes: [], permitted_symbols: [], aliases: false) || {}
  rows << {
    'certname' => File.basename(path, '.yaml'),
    'role' => data['sasd::role'].to_s,
    'lifecycle' => data['sasd::lifecycle_state'].to_s,
    'owner' => data['sasd::owner'].to_s,
    'ticket' => data['sasd::lifecycle_ticket'].to_s,
    'expires_at' => data['sasd::lifecycle_expires_at'].to_s,
    'description' => data['sasd::description'].to_s,
    'source' => path.include?('/retired/') ? 'retired' : 'active',
  }
end

case options[:format]
when 'json'
  puts JSON.pretty_generate({ 'schema_version' => 1, 'generated_at' => Time.now.utc.iso8601, 'nodes' => rows })
when 'csv'
  headers = %w[certname role lifecycle owner ticket expires_at source description]
  puts CSV.generate { |csv| csv << headers; rows.each { |r| csv << headers.map { |h| r[h] } } }
else
  headers = %w[CERTNAME ROLE LIFECYCLE OWNER EXPIRES SOURCE]
  values = rows.map { |r| [r['certname'], r['role'], r['lifecycle'], r['owner'], r['expires_at'], r['source']] }
  widths = headers.each_index.map { |i| ([headers[i].length] + values.map { |v| v[i].length }).max }
  puts headers.each_index.map { |i| headers[i].ljust(widths[i]) }.join('  ')
  puts widths.map { |w| '-' * w }.join('  ')
  values.each { |v| puts v.each_index.map { |i| v[i].ljust(widths[i]) }.join('  ') }
end
