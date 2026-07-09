# frozen_string_literal: true
require 'rake'
ROOT=File.expand_path(__dir__)
def run_script(path,*args) sh(File.join(ROOT,path),*args) end
desc 'Run all static validation checks in strict mode'; task(:validate){run_script('scripts/validate.sh','--strict')}
desc 'Compile supported agent fixture catalogs'; task(:catalog){run_script('scripts/test-catalog.sh')}
desc 'Run RSpec-Puppet unit tests'; task(:spec){sh('bundle','exec','rspec','site-modules')}
desc 'Run all bootstrap, deployment, and operations smoke tests'; task(:bootstrap){run_script('tests/smoke/bootstrap-dry-run.sh');run_script('tests/smoke/server-dry-run.sh');run_script('tests/smoke/central-agent-dry-run.sh');run_script('tests/smoke/ca-argument-validation.sh');run_script('tests/smoke/operations-dry-run.sh');run_script('tests/smoke/report-status.sh');run_script('tests/smoke/health-fixture.sh');run_script('tests/smoke/promotion-guards.sh');run_script('tests/smoke/backup-verification.sh')}
desc 'Run complete Milestone 4 verification suite'; task default: %i[validate spec catalog]
