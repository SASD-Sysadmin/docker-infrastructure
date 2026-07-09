# frozen_string_literal: true
require 'spec_helper'
describe 'profile::platform_state' do
  SUPPORTED_FACTS.each do |platform,platform_facts|
    context "on #{platform}" do
      let(:facts){platform_facts}
      let(:trusted_facts){{'certname'=>platform_facts[:networking]['fqdn'],'authenticated'=>'remote','extensions'=>{}}}
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_file('/etc/sasd/platform.d/current.conf').with(mode:'0644') }
      it 'renders family and provider evidence' do
        content=catalogue.resource('File','/etc/sasd/platform.d/current.conf')[:content]
        expect(content).to include("os_family=#{platform_facts[:os]['family']}")
        expected=platform_facts[:os]['family']=='RedHat' ? 'dnf' : 'apt'
        expect(content).to include("package_provider=#{expected}")
      end
    end
  end
end
