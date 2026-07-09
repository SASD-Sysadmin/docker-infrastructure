# frozen_string_literal: true
require 'spec_helper'
describe 'profile::application_state' do
  let(:facts) { SUPPORTED_FACTS[:debian12] }
  let(:trusted_facts) { { 'certname'=>'server.example.test','authenticated'=>'remote','extensions'=>{} } }
  let(:params) { { role_name:'server', enabled_profiles:['baseline','administration_tools'] } }
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_file('/etc/sasd/applications.d').with(ensure:'directory',mode:'0755') }
  it 'renders non-secret classification evidence' do
    content=catalogue.resource('File','/etc/sasd/applications.d/assigned.conf')[:content]
    expect(content).to include('role=server')
    expect(content).to include('profiles=baseline,administration_tools')
    expect(content).to include('trusted_certname=server.example.test')
  end
end
