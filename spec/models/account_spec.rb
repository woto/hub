# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )      default(0.0), not null
#  code             :integer          not null
#  currency         :integer          not null
#  subjectable_type :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  subjectable_id   :bigint           not null
#
# Indexes
#
#  account_set_uniqueness                                 (code,currency,subjectable_id,subjectable_type) UNIQUE
#  index_accounts_on_subjectable_type_and_subjectable_id  (subjectable_type,subjectable_id)
#
require 'rails_helper'

describe Account, type: :model do
  it_behaves_like 'elasticable'
  it_behaves_like 'logidzable'

  it { is_expected.to have_db_index(%i[code currency subjectable_id subjectable_type]).unique }
  it { is_expected.to define_enum_for(:currency).with_values(GlobalHelper.currencies_table) }

  specify do
    codes = %i[draft pending approved rejected accrued canceled requested payed]
    expect(subject).to define_enum_for(:code).with_values(codes)
  end

  describe 'associations' do
    it { is_expected.to belong_to(:subjectable) }
    it { is_expected.to have_many(:transactions_as_credit).class_name('Transaction').with_foreign_key('credit_id') }
    it { is_expected.to have_many(:transactions_as_debit).class_name('Transaction').with_foreign_key('debit_id') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:currency) }
    it { is_expected.to validate_presence_of(:subjectable) }

    context 'with created account' do
      subject { create(:account) }

      it { is_expected.to validate_presence_of(:amount) }

      specify do
        expect(subject).to validate_uniqueness_of(:currency)
          .scoped_to(%i[code subjectable_id subjectable_type])
          .ignoring_case_sensitivity
      end
    end
  end

  describe '#set_amount_to_zero' do
    context 'when account built with non zero amount' do
      subject { build(:account, amount: 1) }

      it 'sets amount to zero anyway' do
        expect(subject).to be_valid
        expect(subject.amount).to be_zero
      end
    end
  end

  describe '#restrict_change_fields' do
    subject { create(:account, code: :draft, currency: :rub, subjectable: subject_object, amount: 0) }

    let(:subject_object) { create(:subject) }

    it 'does not allow to change code' do
      subject.code = :pending
      expect(subject).to be_invalid
    end

    it 'does not allow to change currency' do
      subject.currency = :usd
      expect(subject).to be_invalid
    end

    it 'does not allow to change subjectable' do
      subject.subjectable = create(:user)
      expect(subject).to be_invalid
    end

    it 'does not allow to change amount' do
      subject.amount = 1
      expect(subject).to be_invalid
    end
  end

  describe '.for_user' do
    subject { described_class.for_user(user, code, currency) }

    let(:user) { create(:user) }
    let(:code) { described_class.codes.keys.sample }
    let(:currency) { described_class.currencies.keys.sample }

    context 'when account already created' do
      it 'finds it' do
        subject
        expect { subject }.not_to change(described_class, :count)
      end
    end

    context 'when account is not created yet' do
      it 'creates new account' do
        expect { subject }.to change(described_class, :count)
      end
    end

    it 'returns account for user' do
      expect(subject).to have_attributes(
        subjectable_id: user.id,
        subjectable_type: 'User',
        code: code,
        currency: currency
      )
    end
  end

  describe '.for_subject' do
    subject { described_class.for_subject(identifier, code, currency) }

    let(:identifier) { 'hub' }
    let(:code) { described_class.codes.keys.sample }
    let(:currency) { described_class.currencies.keys.sample }

    context 'when account already created' do
      it 'finds it' do
        subject
        expect { subject }.not_to change(described_class, :count)
      end
    end

    context 'when account is not created yet' do
      it 'creates new account' do
        expect { subject }.to change(described_class, :count)
      end
    end

    it 'returns account for hub' do
      expect(subject).to have_attributes(
        subjectable_id: Subject.last.id,
        subjectable_type: 'Subject',
        code: code,
        currency: currency
      )
    end
  end

  describe '.subjects' do
    subject { described_class.subjects }

    before { create(:account, :for_user) }

    let!(:account) { create(:account, :for_hub) }

    it 'returns accounts only with `subjectable` type Subject' do
      expect(subject).to eq([account])
    end
  end

  describe '#as_indexed_json' do
    subject { account.as_indexed_json }

    let(:account) { create(:account) }

    it 'returns correct result' do
      expect(subject).to include(
        id: account.id,
        amount: account.amount,
        code: account.code,
        currency: account.currency,
        subjectable_id: account.subjectable_id,
        subjectable_type: account.subjectable_type,
        subjectable_label: account.subjectable.to_label
      )
    end
  end

  describe '#to_label' do
    subject { account.to_label }

    context 'when `subjectable` is a Subject' do
      let(:account) { create(:account, :for_hub) }

      it { is_expected.to eq("hub, #{account.code}, #{account.currency}") }
    end

    context 'when `subjectable` is User' do
      let(:account) { create(:account, :for_user) }

      it { is_expected.to eq("user, #{account.code}, #{account.currency}") }
    end
  end

  describe '.available_to_request' do
    subject { described_class.available_to_request(user, :rub) }

    let(:user) { create(:user) }

    # This strange updates due to the readonly attributes
    before do
      result = described_class.for_user(user, :accrued, :rub)
      described_class.where(id: result.id).update_all(amount: 150)
      result = described_class.for_user(user, :requested, :rub)
      described_class.where(id: result.id).update_all(amount: 50)
      result = described_class.for_user(user, :payed, :rub)
      described_class.where(id: result.id).update_all(amount: 50)

      # other data
      result = described_class.for_user(user, :accrued, :usd)
      described_class.where(id: result.id).update_all(amount: 1)
      result = described_class.for_user(user, :pending, :rub)
      described_class.where(id: result.id).update_all(amount: 1)
      result = described_class.for_user(create(:user), :accrued, :rub)
      described_class.where(id: result.id).update_all(amount: 1)
    end

    it 'calculates correct value as 150-50-50' do
      expect(subject).to eq(50)
    end
  end
end
