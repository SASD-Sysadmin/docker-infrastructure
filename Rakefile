# frozen_string_literal: true
require 'rake'
ROOT=File.expand_path(__dir__)
def run_script(path,*args) sh(File.join(ROOT,path),*args) end
desc 'Run all static validation checks in strict mode'; task(:validate){run_script('scripts/validate.sh','--strict')}
desc 'Compile supported agent fixture catalogs'; task(:catalog){run_script('scripts/test-catalog.sh')}
desc 'Run RSpec-Puppet unit tests'; task(:spec){sh('bundle','exec','rspec','site-modules')}
desc 'Run all bootstrap and deployment dry-runs'; task(:bootstrap){run_script('tests/smoke/bootstrap-dry-run.sh');run_script('tests/smoke/server-dry-run.sh');run_script('tests/smoke/central-agent-dry-run.sh');run_script('tests/smoke/ca-argument-validation.sh')}
desc 'Run complete Milestone 3 verification suite'; task default: %i[validate spec catalog]
