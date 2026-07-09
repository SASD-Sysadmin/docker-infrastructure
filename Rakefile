# frozen_string_literal: true
require 'rake'
ROOT = File.expand_path(__dir__)
def run_script(relative_path, *arguments) sh(File.join(ROOT, relative_path), *arguments) end

desc 'Run all static validation checks in strict mode'
task :validate do run_script('scripts/validate.sh', '--strict') end

desc 'Compile supported platform catalogs in no-op mode'
task :catalog do run_script('scripts/test-catalog.sh') end

desc 'Run RSpec-Puppet unit tests for site modules'
task :spec do sh('bundle', 'exec', 'rspec', 'site-modules') end

desc 'Run the Milestone 2 bootstrap dry-run tests'
task :bootstrap do run_script('tests/smoke/bootstrap-dry-run.sh') end

desc 'Run the complete Milestone 2 verification suite'
task default: %i[validate spec catalog]
