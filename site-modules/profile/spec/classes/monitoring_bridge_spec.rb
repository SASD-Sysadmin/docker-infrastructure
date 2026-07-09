# frozen_string_literal: true
require 'spec_helper'

describe 'profile::monitoring_bridge' do
  let(:facts) { SUPPORTED_FACTS[:debian12] }
  let(:trusted_facts) { { 'certname'=>'puppet.example.test','authenticated'=>'remote','extensions'=>{} } }
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_file('/var/lib/sasd-puppet/monitoring').with(ensure: 'directory', mode: '0750') }
  it { is_expected.to contain_file('/usr/local/sbin/sasd-puppet-monitoring-snapshot').with(mode: '0755') }
  it { is_expected.to contain_service('sasd-puppet-monitoring.timer').with(ensure: 'running', enable: true) }
  it 'renders a hardened service without a network listener' do
    content=catalogue.resource('File','/etc/systemd/system/sasd-puppet-monitoring.service')[:content]
    expect(content).to include('NoNewPrivileges=true')
    expect(content).to include('ProtectSystem=strict')
    expect(content).not_to include('ListenStream')
  end
end
