#!/usr/bin/env ruby
# Correlate node lifecycle data with compact Puppet report summaries.
require 'json'
require 'optparse'
require 'psych'
require 'time'

root = File.expand_path('..', __dir__)
options = { reports: '/var/lib/sasd-puppet/reports', max_age: 7200, format: 'table', now: Time.now.utc }
OptionParser.new do |o|
  o.banner = 'Usage: fleet-compliance.rb [options]'
  o.on('--reports DIRECTORY') { |v| options[:reports] = v }
  o.on('--max-age SECONDS', Integer) { |v| options[:max_age] = v }
  o.on('--format FORMAT') { |v| options[:format] = v }
  o.on('--now UTC') { |v| options[:now] = Time.iso8601(v).utc }
end.parse!
abort('ERROR: format must be table or json') unless %w[table json].include?(options[:format])

rows = []
Dir.glob(File.join(root, 'data/nodes/*.yaml')).sort.each do |path|
  data = Psych.safe_load_file(path, permitted_classes: [], permitted_symbols: [], aliases: false) || {}
  cert = File.basename(path, '.yaml')
  lifecycle = data['sasd::lifecycle_state'].to_s
  status = 'unknown'; detail = ''
  report_path = File.join(options[:reports], "#{cert}.json")

  if lifecycle == 'retired'
    status = 'retired-pending-decommission'
    detail = 'retired record remains in active inventory'
  elsif lifecycle == 'maintenance'
    expiry = data['sasd::lifecycle_expires_at'].to_s
    begin
      if !expiry.empty? && Time.iso8601(expiry) < options[:now]
        status = 'maintenance-expired'; detail = expiry
      else
        status = 'maintenance'; detail = expiry
      end
    rescue ArgumentError
      status = 'invalid-maintenance-expiry'; detail = expiry
    end
  elsif !File.file?(report_path)
    status = 'missing-report'; detail = report_path
  else
    begin
      report = JSON.parse(File.read(report_path))
      report_time = Time.iso8601(report.fetch('time')).utc
      age = options[:now] - report_time
      if age > options[:max_age]
        status = 'stale-report'; detail = "age=#{age.to_i}s"
      elsif report['status'] == 'failed' || report['status'] == 'failure'
        status = 'failed'; detail = report['status'].to_s
      elsif %w[changed unchanged].include?(report['status'])
        status = 'compliant'; detail = "age=#{age.to_i}s"
      else
        status = 'unknown-report-status'; detail = report['status'].to_s
      end
    rescue StandardError => e
      status = 'invalid-report'; detail = e.message
    end
  end
  rows << {
    'certname' => cert,
    'role' => data['sasd::role'].to_s,
    'lifecycle' => lifecycle,
    'owner' => data['sasd::owner'].to_s,
    'status' => status,
    'detail' => detail,
  }
end

severity = lambda do |status|
  return 0 if %w[compliant maintenance].include?(status)
  return 2 if %w[stale-report missing-report maintenance-expired].include?(status)
  3
end
exit_code = rows.map { |r| severity.call(r['status']) }.max || 0
summary = rows.group_by { |r| r['status'] }.transform_values(&:length)
if options[:format] == 'json'
  puts JSON.pretty_generate({ 'schema_version' => 1, 'generated_at' => options[:now].iso8601, 'summary' => summary, 'nodes' => rows })
else
  headers = %w[CERTNAME ROLE LIFECYCLE STATUS DETAIL]
  vals = rows.map { |r| [r['certname'], r['role'], r['lifecycle'], r['status'], r['detail']] }
  widths = headers.each_index.map { |i| ([headers[i].length] + vals.map { |v| v[i].length }).max }
  puts headers.each_index.map { |i| headers[i].ljust(widths[i]) }.join('  ')
  puts widths.map { |w| '-' * w }.join('  ')
  vals.each { |v| puts v.each_index.map { |i| v[i].ljust(widths[i]) }.join('  ') }
  puts "Summary: #{summary.sort.map { |k,v| "#{k}=#{v}" }.join(', ')}"
end
exit exit_code
