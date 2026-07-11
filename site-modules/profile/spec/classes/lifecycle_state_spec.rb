# frozen_string_literal: true
require 'spec_helper'

describe 'profile::lifecycle_state' do
  let(:facts) { SUPPORTED_FACTS[:debian12] }
  let(:trusted_facts) { { 'certname'=>'node.example.test','authenticated'=>'remote','extensions'=>{} } }

  context 'active' do
    let(:params) { { lifecycle_state: 'active' } }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/sasd/lifecycle.d/state.conf').with(mode: '0644') }
    it 'renders active evidence' do
      content=catalogue.resource('File','/etc/sasd/lifecycle.d/state.conf')[:content]
      expect(content).to include('lifecycle_state=active')
      expect(content).to include('trusted_certname=node.example.test')
    end
  end

  context 'maintenance with complete control data' do
    let(:params) do
      { lifecycle_state: 'maintenance', reason: 'Kernel maintenance', ticket: 'CHG-1234', expires_at: '2026-07-10T12:00:00Z' }
    end
    it { is_expected.to compile.with_all_deps }
    it 'renders ticket and expiry' do
      content=catalogue.resource('File','/etc/sasd/lifecycle.d/state.conf')[:content]
      expect(content).to include('ticket=CHG-1234')
      expect(content).to include('expires_at=2026-07-10T12:00:00Z')
    end
  end

  context 'maintenance without ticket' do
    let(:params) { { lifecycle_state: 'maintenance', reason: 'test', expires_at: '2026-07-10T12:00:00Z' } }
    it { is_expected.to compile.and_raise_error(%r{Maintenance lifecycle requires}) }
  end
end
