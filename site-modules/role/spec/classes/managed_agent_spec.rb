# frozen_string_literal: true
require 'spec_helper'

describe 'role::managed_agent' do
  let(:facts) { SUPPORTED_FACTS[:debian12] }
  let(:trusted_facts) { { 'certname'=>'agent.example.test','authenticated'=>'remote','extensions'=>{} } }
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('profile::baseline') }
  it { is_expected.to contain_class('profile::agent_service') }
  it { is_expected.to contain_service('puppet').with(ensure: 'running', enable: true) }
end
