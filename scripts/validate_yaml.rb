#!/usr/bin/env ruby
# frozen_string_literal: true

# Validate every repository YAML file as exactly one YAML document. Psych is
# part of Ruby's standard library, so this check has no Python/PyYAML dependency.
require 'pathname'
require 'psych'

root = Pathname.new(__dir__).parent
excluded = %w[.git vendor modules].freeze
files = %w[**/*.yaml **/*.yml].flat_map do |pattern|
  Dir.glob(root.join(pattern).to_s, File::FNM_DOTMATCH).map { |item| Pathname.new(item) }
end.uniq.reject do |path|
  (path.relative_path_from(root).each_filename.to_a & excluded).any?
end.sort

failures = 0
files.each do |path|
  begin
    stream = Psych.parse_stream(path.read(encoding: 'UTF-8'))
    documents = stream.children.length
    raise "expected one document, found #{documents}" unless documents == 1
  rescue StandardError, Psych::SyntaxError => e
    warn "ERROR: #{path.relative_path_from(root)}: #{e.message}"
    failures += 1
  end
end

if failures.positive?
  warn "YAML validation failed for #{failures} file(s)."
  exit 1
end

puts "YAML validation passed for #{files.length} file(s)."
