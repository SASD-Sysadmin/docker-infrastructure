# frozen_string_literal: true
require 'spec_helper'
describe 'profile::baseline' do
  SUPPORTED_FACTS.each do |platform,platform_facts|
    context "on #{platform}" do
      let(:facts){platform_facts}
      let(:trusted_facts){{'certname'=>platform_facts[:networking]['fqdn'],'authenticated'=>'local','extensions'=>{}}}
      it { is_expected.to compile.with_all_deps }
      PACKAGE_EXPECTATIONS.fetch(platform_facts[:os]['family'].to_sym).fetch(:baseline).each { |name| it { is_expected.to contain_package(name).with_ensure('installed') } }
      it { is_expected.to contain_file('/etc/sasd').with(ensure:'directory',owner:'root',group:'root',mode:'0755') }
      it 'renders identity and version' do
        content=catalogue.resource('File','/etc/sasd/puppet-baseline.conf')[:content]
        expect(content).to include('baseline_version=0.11.0')
        expect(content).to include("trusted_certname=#{platform_facts[:networking]['fqdn']}")
      end
    end
  end
  context 'on unsupported OracleLinux 9' do
    let(:facts){{os:{'family'=>'RedHat','name'=>'OracleLinux','release'=>{'major'=>'9'}},networking:{'fqdn'=>'oracle9.example.test'}}}
    let(:trusted_facts){{'certname'=>'oracle9.example.test','authenticated'=>'remote','extensions'=>{}}}
    it { is_expected.to compile.and_raise_error(%r{does not support OracleLinux 9}) }
  end
end
