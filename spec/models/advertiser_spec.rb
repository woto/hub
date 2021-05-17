# frozen_string_literal: true

# == Schema Information
#
# Table name: advertisers
#
#  id          :bigint           not null, primary key
#  feeds_count :integer          default(0)
#  is_active   :boolean          default(TRUE), not null
#  name        :string
#  network     :integer
#  raw         :text
#  synced_at   :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ext_id      :string
#
# Indexes
#
#  index_advertisers_on_network_and_ext_id  (network,ext_id) UNIQUE
#
require 'rails_helper'

describe Advertiser, type: :model do
  it_behaves_like 'logidzable'

  it { is_expected.to define_enum_for(:network).with_values([:admitad, :gdeslon]) }
  it { is_expected.to have_many(:feeds).dependent(:destroy) }
  it { is_expected.to have_many(:accounts) }
  it { is_expected.to validate_presence_of(:name) }

  describe '#slug' do
    subject { create(:advertiser, name: 'Cuernos y pezuñas') }

    specify do
      expect(subject.slug).to eq('1-cuernos-y-pezunas')
    end
  end

  describe '#to_label' do
    subject { create(:advertiser, name: 'Advertiser') }

    specify do
      expect(subject.to_label).to eq('Advertiser')
    end
  end

  describe '#to_long_label' do
    subject { create(:advertiser, name: 'Advertiser') }

    specify do
      expect(subject.to_long_label).to eq('Advertiser')
    end
  end
end
