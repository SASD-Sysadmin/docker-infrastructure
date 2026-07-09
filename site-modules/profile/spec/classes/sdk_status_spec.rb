# frozen_string_literal: true
require 'spec_helper'
describe 'profile::sdk_status' do
  let(:facts) { SUPPORTED_FACTS[:debian12] }
  let(:trusted_facts) { { 'certname'=>'dev.example.test','authenticated'=>'remote','extensions'=>{} } }
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_file('/etc/sasd/toolchains.d').with(ensure:'directory',mode:'0755') }
  it { is_expected.to contain_file('/usr/local/sbin/sasd-sdk-status').with(mode:'0755') }
end
