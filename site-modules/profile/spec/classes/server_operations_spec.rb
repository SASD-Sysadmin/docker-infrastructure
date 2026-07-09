# frozen_string_literal: true
require 'spec_helper'

describe 'profile::server_operations' do
  let(:facts) { SUPPORTED_FACTS[:debian12] }
  let(:trusted_facts) { { 'certname'=>'puppet.example.test','authenticated'=>'remote','extensions'=>{} } }
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_file('/var/lib/sasd-puppet').with(ensure: 'directory', owner: 'puppet', group: 'puppet', mode: '0750') }
  it { is_expected.to contain_file('/var/lib/sasd-puppet/reports').that_requires('File[/var/lib/sasd-puppet]') }
  it { is_expected.to contain_file('/usr/local/sbin/sasd-puppet-health').with(mode: '0755') }
  it { is_expected.to contain_exec('reload systemd for SASD Puppet operations').with(command: '/bin/systemctl daemon-reload', refreshonly: true) }
  it { is_expected.to contain_service('sasd-puppet-health.timer').with(ensure: 'running', enable: true) }
  it 'renders a hardened health service' do
    content=catalogue.resource('File','/etc/systemd/system/sasd-puppet-health.service')[:content]
    expect(content).to include('NoNewPrivileges=true')
    expect(content).to include('ProtectSystem=strict')
  end
end
