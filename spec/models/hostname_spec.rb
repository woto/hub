# == Schema Information
#
# Table name: hostnames
#
#  id             :bigint           not null, primary key
#  entities_count :integer          default(0), not null
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Hostname, type: :model do
  it { is_expected.to have_many(:mentions).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:entities).dependent(:restrict_with_error) }

  describe '#to_label' do
    subject { create(:hostname, title: 'title') }

    specify do
      expect(subject.to_label).to eq('title')
    end
  end
end
