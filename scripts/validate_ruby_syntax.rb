#!/usr/bin/env ruby
# Validate all tracked Ruby source files in one interpreter process.
root = File.expand_path('..', __dir__)
files = %w[site-modules scripts spec].flat_map do |directory|
  Dir.glob(File.join(root, directory, '**', '*.rb'))
end.sort
errors = []
files.each do |path|
  begin
    RubyVM::InstructionSequence.compile_file(path)
  rescue SyntaxError => e
    errors << "#{path.delete_prefix(root + '/')}: #{e.message}"
  end
end
unless errors.empty?
  warn errors.map { |error| "ERROR: #{error}" }.join("\n")
  exit 1
end
puts "Ruby syntax validation passed for #{files.length} file(s)."
