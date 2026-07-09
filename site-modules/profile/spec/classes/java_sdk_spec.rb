# frozen_string_literal: true
require 'spec_helper'
describe 'profile::java_sdk' do
  SUPPORTED_FACTS.each do |platform,platform_facts|
    context "on #{platform}" do
      let(:facts){platform_facts}
      let(:trusted_facts){{'certname'=>platform_facts[:networking]['fqdn'],'authenticated'=>'remote','extensions'=>{}}}
      it { is_expected.to compile.with_all_deps }
      PACKAGE_EXPECTATIONS.fetch(platform_facts[:os]['family'].to_sym).fetch(:java_sdk).each { |name| it { is_expected.to contain_package(name).with_ensure('installed') } }
      it 'records Java 17 and Maven policy' do
        content=catalogue.resource('File','/etc/sasd/toolchains.d/java.conf')[:content]
        expect(content).to include('expected_java_major=17')
        expect(content).to include('build_tool=maven')
      end
    end
  end
end
