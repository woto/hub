# frozen_string_literal: true

require 'rails_helper'

describe PaginationRules do
  subject do
    described_class.call(request, default_per, max_per, per_variants)
  end

  before do
    stub_const("PaginationRules::PER_VARIANTS", per_variants)
  end

  let(:request) do
    ActionDispatch::TestRequest.create.tap do |r|
      r.params[:per] = per
      r.params[:page] = page
      r.params[:controller] = model
      Session::Tables::(r, model).per = session_per
    end
  end

  let(:per_variants) do
    [5, 10, 20, 30, 50, 100]
  end

  let(:per) do
    10
  end

  let(:page) do
    5
  end

  let(:default_per) do
    20
  end

  let(:max_per) do
    50
  end

  let(:session_per) do
    5
  end

  let(:model) do
    'tests'
  end

  it { is_expected.to eq([page, per]) }

  describe 'page' do

    context 'when page is blank' do
      let(:page) { nil }
      it { is_expected.to eq([1, per]) }
    end

    context 'when page is less than 1' do
      let(:page) { -1 }
      it { is_expected.to eq([1, per]) }
    end

    context 'when page is ordinary value' do
      let(:page) { 100 }
      it { is_expected.to eq([100, per]) }
    end

    context 'when page is a character' do
      let(:page) { 'a' }
      it { is_expected.to eq([1, per]) }
    end
  end

  describe 'per' do

    context 'when per is nil' do
      let(:per) { nil }

      context 'when session is empty' do
        let (:session_per) { nil }
        it { is_expected.to eq([5, default_per]) }
      end

      context 'when session per is outdated value' do
        let(:session_per) { 37 }
        it { is_expected.to eq([page, default_per]) }
      end
    end

    context 'when per is more than max_per' do
      let(:per) { 1000 }
      it { is_expected.to eq([page, max_per]) }
    end

    context 'when per is ordinary' do
      let(:per) { 30 }
      it { is_expected.to eq([page, 30]) }
    end

    context 'when per is a character' do
      let(:per) { 'a' }
      it { is_expected.to eq([page, session_per]) }
    end

    context 'when per is less than 1' do
      let(:per) { -1 }
      it { is_expected.to eq([page, session_per]) }
    end

    context 'when per is not included in per_variants' do
      let(:per) { 1234 }
      it { is_expected.to eq([page, session_per]) }
    end

    context 'per parameter have to be stored in session' do
      let(:per) { 10 }
      it do
        subject
        expect(Session::Tables::(request).per).to eq(per)
      end
      it { expect(session_per).to_not eq(per)}
    end
  end
end
