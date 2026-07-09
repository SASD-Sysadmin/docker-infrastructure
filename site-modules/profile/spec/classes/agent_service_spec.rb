# frozen_string_literal: true
require 'spec_helper'

describe 'profile::agent_service' do
  let(:facts) { SUPPORTED_FACTS[:debian12] }
  context 'with remote authentication' do
    let(:trusted_facts) { { 'certname'=>'agent.example.test','authenticated'=>'remote','extensions'=>{} } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_service('puppet').with(ensure: 'running', enable: true) }
  end
  context 'with local puppet apply authentication' do
    let(:trusted_facts) { { 'certname'=>'agent.example.test','authenticated'=>'local','extensions'=>{} } }
    it { is_expected.to compile.and_raise_error(%r{requires a remotely authenticated}) }
  end
end
