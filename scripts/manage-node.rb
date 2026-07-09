#!/usr/bin/env ruby
# Create and transition reviewed per-node Hiera records atomically.
require 'json'
require 'optparse'
require 'psych'
require 'tempfile'
require 'time'

root = File.expand_path('..', __dir__)
contract = JSON.parse(File.read(File.join(root, 'config/node-data-contract.json')))
options = { dry_run: false }
parser = OptionParser.new do |o|
  o.banner = 'Usage: manage-node.rb COMMAND --certname NAME [options]\nCommands: register, activate, maintenance, retire'
  o.on('--certname NAME') { |v| options[:certname] = v }
  o.on('--role ROLE') { |v| options[:role] = v }
  o.on('--owner OWNER') { |v| options[:owner] = v }
  o.on('--description TEXT') { |v| options[:description] = v }
  o.on('--reason TEXT') { |v| options[:reason] = v }
  o.on('--ticket ID') { |v| options[:ticket] = v }
  o.on('--expires-at UTC') { |v| options[:expires_at] = v }
  o.on('--dry-run') { options[:dry_run] = true }
end
command = ARGV.shift
begin parser.parse!(ARGV); rescue OptionParser::ParseError => e; warn e.message; warn parser; exit 64; end
abort(parser.to_s) unless %w[register activate maintenance retire].include?(command)
certname = options[:certname].to_s
abort('ERROR: --certname is required') if certname.empty?
abort('ERROR: invalid certname') unless certname.match?(Regexp.new(contract.fetch('certname_pattern')))
path = File.join(root, 'data/nodes', "#{certname}.yaml")

def load_yaml(path)
  Psych.safe_load_file(path, permitted_classes: [], permitted_symbols: [], aliases: false) || {}
end

def write_atomic(path, data, dry_run)
  text = Psych.dump(data, line_width: -1)
  if dry_run
    puts text
    return
  end
  FileUtils.mkdir_p(File.dirname(path))
  tmp = Tempfile.new(['node-data-', '.yaml'], File.dirname(path))
  begin
    tmp.write(text); tmp.flush; tmp.fsync; tmp.close
    File.chmod(0o644, tmp.path)
    File.rename(tmp.path, path)
  ensure
    tmp.close! if File.exist?(tmp.path)
  end
end
require 'fileutils'

if command == 'register'
  abort("ERROR: node already exists: #{path}") if File.exist?(path)
  role = options[:role].to_s; owner = options[:owner].to_s
  abort('ERROR: --role is required and must be allowlisted') unless contract.fetch('allowed_roles').include?(role)
  abort('ERROR: --owner is required') if owner.empty?
  data = {
    'sasd::role' => role,
    'sasd::lifecycle_state' => 'active',
    'sasd::owner' => owner,
  }
  data['sasd::description'] = options[:description] unless options[:description].to_s.empty?
else
  abort("ERROR: node record not found: #{path}") unless File.file?(path)
  data = load_yaml(path)
  case command
  when 'activate'
    data['sasd::lifecycle_state'] = 'active'
    %w[sasd::lifecycle_reason sasd::lifecycle_ticket sasd::lifecycle_expires_at].each { |k| data.delete(k) }
  when 'maintenance'
    %i[reason ticket expires_at].each { |k| abort("ERROR: --#{k.to_s.tr('_','-')} is required") if options[k].to_s.empty? }
    begin
      parsed = Time.iso8601(options[:expires_at])
      abort('ERROR: --expires-at must be UTC and end in Z') unless options[:expires_at].end_with?('Z') && parsed.utc?
    rescue ArgumentError
      abort('ERROR: --expires-at must be valid UTC RFC3339')
    end
    data['sasd::lifecycle_state'] = 'maintenance'
    data['sasd::lifecycle_reason'] = options[:reason]
    data['sasd::lifecycle_ticket'] = options[:ticket]
    data['sasd::lifecycle_expires_at'] = options[:expires_at]
  when 'retire'
    %i[reason ticket].each { |k| abort("ERROR: --#{k} is required") if options[k].to_s.empty? }
    data['sasd::lifecycle_state'] = 'retired'
    data['sasd::lifecycle_reason'] = options[:reason]
    data['sasd::lifecycle_ticket'] = options[:ticket]
    data.delete('sasd::lifecycle_expires_at')
  end
end
write_atomic(path, data, options[:dry_run])
puts "#{options[:dry_run] ? 'Would update' : 'Updated'} #{path}" unless options[:dry_run]
