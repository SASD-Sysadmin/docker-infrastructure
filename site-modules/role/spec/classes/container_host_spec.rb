# frozen_string_literal: true
require 'spec_helper'
describe 'role::container_host' do
  let(:facts) { SUPPORTED_FACTS[:debian12] }
  let(:trusted_facts) { { 'certname'=>'container_host.example.test','authenticated'=>'remote','extensions'=>{} } }
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('profile::baseline') }
  it { is_expected.to contain_class('profile::administration_tools') }
  it { is_expected.to contain_class('profile::container_tools') }
  it { is_expected.to contain_class('profile::application_state') }
  it { is_expected.to contain_class('profile::agent_service') }
end
