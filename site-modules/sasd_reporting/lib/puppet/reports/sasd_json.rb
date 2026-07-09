# frozen_string_literal: true

require 'json'
require 'fileutils'
require 'puppet'
require 'time'

Puppet::Reports.register_report(:sasd_json) do
  desc 'Write a compact, non-secret JSON status summary for SASD monitoring.'

  def process
    directory = ENV.fetch('SASD_PUPPET_REPORT_DIR', '/var/lib/sasd-puppet/reports')
    FileUtils.mkdir_p(directory, mode: 0o750)
    safe_host = host.to_s.downcase.gsub(/[^a-z0-9._-]/, '_')
    raise Puppet::Error, 'sasd_json report has an empty certname' if safe_host.empty?

    event_counts = Hash.new(0)
    Array(resource_statuses&.values).each do |resource|
      Array(resource.events).each { |event| event_counts[event.status.to_s] += 1 }
    end

    payload = {
      schema_version: 1,
      certname: host.to_s,
      environment: environment.to_s,
      configuration_version: configuration_version.to_s,
      transaction_uuid: transaction_uuid.to_s,
      status: status.to_s,
      noop: !!noop,
      time: time&.utc&.iso8601,
      start_time: time&.utc&.iso8601,
      end_time: end_time&.utc&.iso8601,
      event_counts: event_counts.sort.to_h
    }

    final_path = File.join(directory, "#{safe_host}.json")
    temporary_path = "#{final_path}.tmp.#{Process.pid}"
    File.open(temporary_path, File::WRONLY | File::CREAT | File::TRUNC, 0o640) do |file|
      file.write(JSON.pretty_generate(payload))
      file.write("\n")
      file.flush
      file.fsync
    end
    File.rename(temporary_path, final_path)
  rescue StandardError => e
    Puppet.err("sasd_json report processor failed: #{e.class}: #{e.message}")
  ensure
    File.delete(temporary_path) if defined?(temporary_path) && temporary_path && File.exist?(temporary_path)
  end
end
