# frozen_string_literal: true

require 'rake'

ROOT = File.expand_path(__dir__)

# Run a repository script and stop immediately when it fails.
def run_script(relative_path, *arguments)
  command = [File.join(ROOT, relative_path), *arguments]
  sh(*command)
end

desc 'Run all static validation checks in strict mode'
task :validate do
  run_script('scripts/validate.sh', '--strict')
end

desc 'Compile and apply the workload-free catalog in no-op mode'
task :catalog do
  run_script('scripts/test-catalog.sh')
end

desc 'Run the RSpec-Puppet unit tests for site modules'
task :spec do
  sh('bundle', 'exec', 'rspec', 'site-modules')
end

desc 'Run the complete Milestone 1 verification suite'
task default: %i[validate spec catalog]
