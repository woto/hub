# frozen_string_literal: true

# == Schema Information
#
# Table name: transaction_groups
#
#  id         :bigint           not null, primary key
#  kind       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

describe TransactionGroup, type: :model do
  # it_behaves_like 'elasticable'
  it { is_expected.to define_enum_for(:kind).with_values(['accounting/main/change_status']) }
  it { is_expected.to have_many(:transactions) }

  describe '#start' do
    let(:block) { ->(_) {} }

    specify do
      transaction_group = instance_double(TransactionGroup)
      expect(described_class).to receive(:create!).with(kind: 'accounting/main/change_status').and_return(transaction_group)
      expect(transaction_group).to receive(:tap).and_return(transaction_group)
      described_class.start(Accounting::Main::ChangeStatusInteractor, &block)
    end
  end
end
