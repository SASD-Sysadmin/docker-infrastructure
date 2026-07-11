# frozen_string_literal: true
require 'spec_helper'
describe 'role::apt_repository_client' do
  let(:facts){SUPPORTED_FACTS[:debian12]}
  let(:trusted_facts){{'certname'=>'apt-client.example.test','authenticated'=>'remote','extensions'=>{}}}
  let(:hiera_data){{
    'sasd::role'=>'apt_repository_client',
    'profile::apt_repository_credentials::machine'=>'packages.example.test',
    'profile::apt_repository_credentials::login'=>'sasd-readonly',
    'profile::apt_repository_credentials::password'=>'unit-test-token'
  }}
  it { is_expected.to compile.with_all_deps }
  %w[baseline platform_state administration_tools apt_repository_credentials lifecycle_state application_state agent_service].each { |name| it { is_expected.to contain_class("profile::#{name}") } }
end
