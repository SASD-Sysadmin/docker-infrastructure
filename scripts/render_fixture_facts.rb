#!/usr/bin/env ruby
# Convert a YAML/JSON fact fixture into high-weight temporary custom facts.
# This is used only by no-op catalog tests because puppet apply itself does not
# provide puppet lookup's --facts option.
require 'json'
require 'psych'

abort "Usage: #{File.basename($PROGRAM_NAME)} INPUT OUTPUT" unless ARGV.length == 2
input, output = ARGV
facts = Psych.safe_load_file(input, permitted_classes: [], permitted_symbols: [], aliases: false)
abort 'Fact fixture must contain a mapping' unless facts.is_a?(Hash)

File.open(output, 'w', 0o600) do |file|
  file.puts "# Generated test facts. Do not install this file on a real node."
  file.puts "require 'json'"
  facts.each do |name, value|
    fact_name = name.to_s
    json = JSON.generate(value)
    file.puts <<~FACT

      Facter.add(#{fact_name.to_sym.inspect}) do
        has_weight 100_000
        setcode { JSON.parse(#{json.inspect}) }
      end
    FACT
  end
end
