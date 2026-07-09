# frozen_string_literal: true

require 'spec_helper'

describe 'profile::baseline' do
  SUPPORTED_FACTS.each do |platform, platform_facts|
    context "on #{platform}" do
      let(:facts) { platform_facts }
      let(:trusted_facts) do
        { 'certname' => platform_facts[:networking]['fqdn'], 'authenticated' => 'local', 'extensions' => {} }
      end

      it { is_expected.to compile.with_all_deps }

      EXPECTED_COMMON_PACKAGES.each do |package_name|
        it { is_expected.to contain_package(package_name).with_ensure('installed') }
      end

      it do
        is_expected.to contain_file('/etc/sasd').with(
          ensure: 'directory', owner: 'root', group: 'root', mode: '0755'
        )
      end

      it do
        is_expected.to contain_file('/etc/sasd/puppet-baseline.conf').with(
          ensure: 'file', owner: 'root', group: 'root', mode: '0644'
        ).that_requires('File[/etc/sasd]')
      end

      it 'renders platform identity into the marker file' do
        content = catalogue.resource('File', '/etc/sasd/puppet-baseline.conf')[:content]
        expect(content).to include("platform=#{platform_facts[:os]['name']}")
        expect(content).to include('baseline_version=0.2.0')
      end
    end
  end

  context 'on an unsupported platform' do
    let(:facts) do
      {
        os: { 'family' => 'RedHat', 'name' => 'Rocky', 'release' => { 'major' => '9' } },
        networking: { 'fqdn' => 'rocky9.example.test' }
      }
    end

    let(:trusted_facts) do
      { 'certname' => 'rocky9.example.test', 'authenticated' => 'local', 'extensions' => {} }
    end

    it { is_expected.to compile.and_raise_error(%r{does not support Rocky 9}) }
  end
end
