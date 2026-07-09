# frozen_string_literal: true
require 'spec_helper'
describe 'profile::development_tools' do
  let(:facts) { SUPPORTED_FACTS[:debian12] }
  let(:trusted_facts) { { 'certname'=>'dev.example.test','authenticated'=>'remote','extensions'=>{} } }
  it { is_expected.to compile.with_all_deps }
  EXPECTED_DEVELOPMENT_PACKAGES.each { |name| it { is_expected.to contain_package(name).with_ensure('installed') } }
end
