# frozen_string_literal: true
require 'spec_helper'

describe 'role::puppet_server' do
  let(:facts) { SUPPORTED_FACTS[:debian12] }
  let(:trusted_facts) { { 'certname'=>'puppet.example.test','authenticated'=>'remote','extensions'=>{} } }
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('profile::baseline') }
  it { is_expected.to contain_class('profile::administration_tools') }
  it { is_expected.to contain_class('profile::lifecycle_state') }
  it { is_expected.to contain_class('profile::application_state') }
  it { is_expected.to contain_class('profile::agent_service') }
  it { is_expected.to contain_class('profile::server_operations') }
  it { is_expected.to contain_service('sasd-puppet-health.timer') }
end
