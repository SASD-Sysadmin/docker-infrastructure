# frozen_string_literal: true
require 'rake'
ROOT=File.expand_path(__dir__)
def run_script(path,*args) sh(File.join(ROOT,path),*args) end
desc 'Run all static validation checks in strict mode'; task(:validate){run_script('scripts/validate.sh','--strict')}
desc 'Compile supported agent fixture catalogs'; task(:catalog){run_script('scripts/test-catalog.sh')}
desc 'Run RSpec-Puppet unit tests'; task(:spec){sh('bundle','exec','rspec','site-modules')}
desc 'Run Milestone 6 smoke tests'
task(:smoke) do
  %w[
    tests/smoke/bootstrap-dry-run.sh
    tests/smoke/server-dry-run.sh
    tests/smoke/central-agent-dry-run.sh
    tests/smoke/ca-argument-validation.sh
    tests/smoke/operations-dry-run.sh
    tests/smoke/report-status.sh
    tests/smoke/health-fixture.sh
    tests/smoke/promotion-guards.sh
    tests/smoke/backup-verification.sh
    tests/smoke/application-policy.sh
    tests/smoke/role-catalog.sh
    tests/smoke/release-manifest.sh
    tests/smoke/release-readiness.sh
    tests/smoke/node-lifecycle.sh
    tests/smoke/inventory-compliance.sh
    tests/smoke/secret-policy.sh
    tests/smoke/decommission-guards.sh
  ].each { |path| run_script(path) }
end
desc 'Run complete Milestone 6 verification suite'; task default: %i[validate spec catalog smoke]
