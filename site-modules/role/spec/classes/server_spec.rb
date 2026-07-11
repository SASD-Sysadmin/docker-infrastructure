# frozen_string_literal: true
require 'spec_helper'
describe 'role::server' do
  SUPPORTED_FACTS.each do |platform,platform_facts|
    context "on #{platform}" do
      let(:facts){platform_facts}
      let(:trusted_facts){{'certname'=>platform_facts[:networking]['fqdn'],'authenticated'=>'remote','extensions'=>{}}}
      it { is_expected.to compile.with_all_deps }
      %w[baseline platform_state administration_tools lifecycle_state application_state agent_service].each { |name| it { is_expected.to contain_class("profile::#{name}") } }
    end
  end
end
