# frozen_string_literal: true
require 'spec_helper'
describe 'profile::php_sdk' do
  SUPPORTED_FACTS.each do |platform,platform_facts|
    context "on #{platform}" do
      let(:facts){platform_facts}
      let(:trusted_facts){{'certname'=>platform_facts[:networking]['fqdn'],'authenticated'=>'remote','extensions'=>{}}}
      it { is_expected.to compile.with_all_deps }
      PACKAGE_EXPECTATIONS.fetch(platform_facts[:os]['family'].to_sym).fetch(:php_sdk).each { |name| it { is_expected.to contain_package(name).with_ensure('installed') } }
      it 'records distribution PHP policy and no web-server management' do
        content=catalogue.resource('File','/etc/sasd/toolchains.d/php.conf')[:content]
        expect(content).to include('version_policy=distribution')
        expect(content).to include('web_server_managed=false')
        expected=platform_facts[:os]['family']=='Debian' ? 'true' : 'false'
        expect(content).to include("composer_expected=#{expected}")
      end
    end
  end
end
