# frozen_string_literal: true
require 'json'
require 'tmpdir'
require 'puppet'
require_relative '../../../lib/puppet/reports/sasd_json'

describe 'sasd_json report processor' do
  it 'registers the report processor' do
    expect(Puppet::Reports.report(:sasd_json)).not_to be_nil
  end

  it 'writes a compact atomic JSON summary' do
    Dir.mktmpdir do |directory|
      old=ENV['SASD_PUPPET_REPORT_DIR']; ENV['SASD_PUPPET_REPORT_DIR']=directory
      report=Object.new.extend(Puppet::Reports.report(:sasd_json))
      values={host:'node01.example.test',environment:'production',configuration_version:'abc123',transaction_uuid:'uuid',status:'changed',noop:false,time:Time.utc(2026,7,9,12,0,0),end_time:Time.utc(2026,7,9,12,0,2),resource_statuses:{}}
      values.each { |name,value| report.define_singleton_method(name){ value } }
      report.process
      payload=JSON.parse(File.read(File.join(directory,'node01.example.test.json')))
      expect(payload['certname']).to eq('node01.example.test')
      expect(payload['status']).to eq('changed')
      expect(payload).not_to have_key('logs')
      expect(payload).not_to have_key('facts')
    ensure
      ENV['SASD_PUPPET_REPORT_DIR']=old
    end
  end
end
