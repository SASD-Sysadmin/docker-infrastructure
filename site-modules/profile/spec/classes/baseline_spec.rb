# frozen_string_literal: true
require 'spec_helper'

describe 'profile::baseline' do
  SUPPORTED_FACTS.each do |platform, platform_facts|
    context "on #{platform}" do
      let(:facts) { platform_facts }
      let(:trusted_facts) { { 'certname' => platform_facts[:networking]['fqdn'], 'authenticated' => 'local', 'extensions' => {} } }
      it { is_expected.to compile.with_all_deps }
      EXPECTED_COMMON_PACKAGES.each { |name| it { is_expected.to contain_package(name).with_ensure('installed') } }
      it { is_expected.to contain_file('/etc/sasd').with(ensure: 'directory', owner: 'root', group: 'root', mode: '0755') }
      it { is_expected.to contain_file('/etc/sasd/puppet-baseline.conf').with(ensure: 'file', owner: 'root', group: 'root', mode: '0644').that_requires('File[/etc/sasd]') }
      it 'renders local identity and version' do
        content=catalogue.resource('File','/etc/sasd/puppet-baseline.conf')[:content]
        expect(content).to include('baseline_version=0.4.0')
        expect(content).to include('management_mode=local-puppet-apply')
        expect(content).to include("trusted_certname=#{platform_facts[:networking]['fqdn']}")
      end
    end
  end
  context 'with remote Puppet Server authentication' do
    let(:facts) { SUPPORTED_FACTS[:debian12] }
    let(:trusted_facts) { { 'certname'=>'agent.example.test','authenticated'=>'remote','extensions'=>{} } }
    it 'records central management mode' do
      expect(catalogue.resource('File','/etc/sasd/puppet-baseline.conf')[:content]).to include('management_mode=puppet-server')
    end
  end
  context 'on unsupported Rocky 9' do
    let(:facts) { { os:{'family'=>'RedHat','name'=>'Rocky','release'=>{'major'=>'9'}}, networking:{'fqdn'=>'rocky9.example.test'} } }
    let(:trusted_facts) { { 'certname'=>'rocky9.example.test','authenticated'=>'remote','extensions'=>{} } }
    it { is_expected.to compile.and_raise_error(%r{does not support Rocky 9}) }
  end
end
