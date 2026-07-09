# frozen_string_literal: true
require 'spec_helper'
describe 'profile::container_tools' do
  let(:facts) { SUPPORTED_FACTS[:ubuntu2404] }
  let(:trusted_facts) { { 'certname'=>'container.example.test','authenticated'=>'remote','extensions'=>{} } }
  it { is_expected.to compile.with_all_deps }
  EXPECTED_CONTAINER_PACKAGES.each { |name| it { is_expected.to contain_package(name).with_ensure('installed') } }
  it { is_expected.not_to contain_service('docker') }
end
