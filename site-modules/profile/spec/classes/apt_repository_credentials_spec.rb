# frozen_string_literal: true
require 'spec_helper'
describe 'profile::apt_repository_credentials' do
  context 'on Debian with centrally authenticated facts' do
    let(:facts){SUPPORTED_FACTS[:debian12]}
    let(:trusted_facts){{'certname'=>'apt-client.example.test','authenticated'=>'remote','extensions'=>{}}}
    let(:hiera_data){{
      'profile::apt_repository_credentials::machine'=>'packages.example.test',
      'profile::apt_repository_credentials::login'=>'sasd-readonly',
      'profile::apt_repository_credentials::password'=>'unit-test-token'
    }}
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/apt/auth.conf.d/sasd-private-repository.conf').with_mode('0600').with_show_diff(false) }
    it 'renders the credential as sensitive content' do
      content=catalogue.resource('File','/etc/apt/auth.conf.d/sasd-private-repository.conf')[:content]
      expect(content).to be_a(Puppet::Pops::Types::PSensitiveType::Sensitive)
      expect(content.unwrap).to include('machine packages.example.test','login sasd-readonly','password unit-test-token')
    end
  end
  context 'on RedHat family' do
    let(:facts){SUPPORTED_FACTS[:rocky9]}
    let(:trusted_facts){{'certname'=>'rocky.example.test','authenticated'=>'remote','extensions'=>{}}}
    let(:hiera_data){{'profile::apt_repository_credentials::machine'=>'packages.example.test','profile::apt_repository_credentials::login'=>'reader','profile::apt_repository_credentials::password'=>'token'}}
    it { is_expected.to compile.and_raise_error(/Debian OS family/) }
  end
end
