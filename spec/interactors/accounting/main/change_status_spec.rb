# frozen_string_literal: true

require 'rails_helper'

describe Accounting::Main::ChangeStatus do
  let(:admin) { create(:user, role: 'admin') }
  let(:transaction_group) { create(:transaction_group, kind: 'accounting/main/change_status') }

  before do
    allow(TransactionGroup).to(receive(:start).with(described_class).and_yield(transaction_group))
  end

  context 'when record is a new post' do
    let(:post) { build(:post) }

    it 'calls `Accounting::CreateTransaction.call` with correct params' do
      allow(Accounting::CreateTransaction).to receive(:call)

      Current.set(responsible: admin) do
        post.save
      end

      expect(Accounting::CreateTransaction).to have_received(:call)
        .with(
          credit: Account.for_subject(:hub, post.status, post.currency),
          debit: Account.for_user(post.user, post.status, post.currency),
          amount: post.amount,
          group: transaction_group,
          obj: post
        )
    end
  end

  context 'when record is a persisted post' do
    let!(:post) do
      Current.set(responsible: admin) do
        create(:post)
      end
    end

    it 'calls `Accounting::CreateTransaction.call` with correct params twice' do
      allow(Accounting::CreateTransaction).to receive(:call)

      from_user = post.user
      from_status = post.status
      from_amount = post.amount
      from_currency = post.currency

      Current.set(responsible: admin) do
        post.update!(
          status: Post.statuses.keys.sample,
          amount: rand(100),
          user: create(:user),
          currency: %i[rub usd eur].sample
        )
      end

      expect(Accounting::CreateTransaction).to have_received(:call)
        .with(
          credit: Account.for_user(from_user, from_status, from_currency),
          debit: Account.for_subject(:hub, from_status, from_currency),
          amount: from_amount,
          group: transaction_group,
          obj: post
        )

      expect(Accounting::CreateTransaction).to have_received(:call)
        .with(
          credit: Account.for_subject(:hub, post.status, post.currency),
          debit: Account.for_user(post.user, post.status, post.currency),
          amount: post.amount,
          group: transaction_group,
          obj: post
        )
    end
  end

  describe 'policy invocation check' do
    subject { described_class.call(record: build(:feed_category)) }

    let(:status_policy) { instance_double(Accounting::Main::PostStatusPolicy) }
    let(:status_context) { instance_double(Accounting::Main::StatusContext) }
    let!(:to_status) { Post.statuses.keys.sample }

    before do
      expect(Accounting::Main::StatusContext).to(
        receive(:new).with(record: post, from_status: from_status).and_return(status_context)
      )
      expect(Accounting::Main::PostStatusPolicy).to(
        receive(:new).with(admin, status_context).and_return(status_policy)
      )
    end

    context 'when post is not persisted yet' do
      let!(:post) { build(:post) }
      let!(:from_status) { nil }

      it 'invokes policy check' do
        expect(status_policy).to receive("to_#{to_status}?").and_return(true)
        Current.set(responsible: admin) { post.update(status: to_status) }
      end
    end

    context 'when post is already persisted' do
      let!(:post) { Current.set(responsible: admin) { create(:post) }}
      let!(:from_status) { post.status }

      it 'invokes policy check' do
        expect(status_policy).to receive("to_#{to_status}?").and_return(true)
        Current.set(responsible: admin) { post.update(status: to_status) }
      end
    end
  end

  context 'when record is instance of not allowed class' do
    subject { described_class.call(record: build(:feed_category)) }

    it { expect { subject }.to raise_error(StandardError, { record: ['must be instance of Check or Post'] }.to_json) }
  end
end
