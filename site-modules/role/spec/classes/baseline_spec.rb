# frozen_string_literal: true

require 'spec_helper'

describe 'role::baseline' do
  SUPPORTED_FACTS.each do |platform, platform_facts|
    context "on #{platform}" do
      let(:facts) { platform_facts }
      let(:trusted_facts) do
        { 'certname' => platform_facts[:networking]['fqdn'], 'authenticated' => 'local', 'extensions' => {} }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('profile::baseline') }
  it { is_expected.to contain_class('profile::platform_state') }
      it { is_expected.to contain_package('git').with_ensure('installed') }
      it { is_expected.to contain_file('/etc/sasd/puppet-baseline.conf') }
    end
  end
end
