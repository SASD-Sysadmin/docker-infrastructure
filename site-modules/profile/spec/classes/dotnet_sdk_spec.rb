# frozen_string_literal: true
require 'spec_helper'
describe 'profile::dotnet_sdk' do
  SUPPORTED_FACTS.each do |platform,platform_facts|
    context "on #{platform}" do
      let(:facts){platform_facts}
      let(:trusted_facts){{'certname'=>platform_facts[:networking]['fqdn'],'authenticated'=>'remote','extensions'=>{}}}
      let(:params){{repository_strategy: platform_facts[:os]['name']=='Debian' ? 'microsoft' : 'distribution'}}
      it { is_expected.to compile.with_all_deps }
      PACKAGE_EXPECTATIONS.fetch(platform_facts[:os]['family'].to_sym).fetch(:dotnet_sdk).each { |name| it { is_expected.to contain_package(name).with_ensure('installed') } }
      it 'records .NET 10 and repository strategy' do
        content=catalogue.resource('File','/etc/sasd/toolchains.d/dotnet.conf')[:content]
        expect(content).to include('expected_dotnet_major=10')
        expect(content).to include("repository_strategy=#{platform_facts[:os]['name']=='Debian' ? 'microsoft' : 'distribution'}")
      end
    end
  end
end
