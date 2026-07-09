# frozen_string_literal: true

require 'spec_helper'

describe 'role::baseline' do
  let(:facts) do
    {
      os: {
        'family' => 'Debian',
        'name' => 'Debian',
        'release' => { 'major' => '12' }
      }
    }
  end

  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('profile::baseline') }

  it 'does not manage workload resources in Milestone 1' do
    expect(non_structural_resources(catalog)).to be_empty
  end
end
