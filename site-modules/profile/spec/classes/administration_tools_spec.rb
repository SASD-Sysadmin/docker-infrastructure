# frozen_string_literal: true
require 'spec_helper'
describe 'profile::administration_tools' do
  SUPPORTED_FACTS.each do |platform, platform_facts|
    context "on #{platform}" do
      let(:facts) { platform_facts }
      let(:trusted_facts) { { 'certname'=>platform_facts[:networking]['fqdn'],'authenticated'=>'remote','extensions'=>{} } }
      it { is_expected.to compile.with_all_deps }
      EXPECTED_ADMIN_PACKAGES.each { |name| it { is_expected.to contain_package(name).with_ensure('installed') } }
    end
  end
end
