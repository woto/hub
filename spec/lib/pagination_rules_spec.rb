# frozen_string_literal: true

require 'rails_helper'

describe PaginationRules do
  subject do
    described_class.new(request, default_per, max_per, per_variants)
  end

  before do
    stub_const('PaginationRules::PER_VARIANTS', per_variants)
  end

  let(:request) do
    ActionDispatch::TestRequest.create.tap do |r|
      r.params[:per] = per
      r.params[:page] = page
      r.params[:controller] = model
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

  let(:model) do
    'tests'
  end

  it { expect(subject.page).to eq(page) }
  it { expect(subject.per).to eq(per) }

  describe 'page' do
    context 'when page is blank' do
      let(:page) { nil }

      it { expect(subject.page).to eq(1) }
      it { expect(subject.per).to eq(per) }
    end

    context 'when page is less than 1' do
      let(:page) { -1 }

      it { expect(subject.page).to eq(1) }
      it { expect(subject.per).to eq(per) }
    end

    context 'when page is ordinary value' do
      let(:page) { 100 }

      it { expect(subject.page).to eq(100) }
      it { expect(subject.per).to eq(per) }
    end

    context 'when page is a character' do
      let(:page) { 'a' }

      it { expect(subject.page).to eq(1) }
      it { expect(subject.per).to eq(per) }
    end
  end

  describe 'per' do
    context 'when per is nil' do
      let(:per) { nil }

      context 'when session is empty' do
        it { expect(subject.page).to eq(5) }
        it { expect(subject.per).to eq(default_per) }
      end
    end

    context 'when per is ordinary' do
      let(:per) { 30 }

      it { expect(subject.page).to eq(page) }
      it { expect(subject.per).to eq(30) }
    end

    context 'when per is invalid' do
      context 'when per is more than max_per' do
        let(:per) { 1000 }

        it { expect(subject.page).to eq(page) }
        it { expect(subject.per).to eq(max_per) }
      end

      context 'when per is a character' do
        let(:per) { 'a' }

        it { expect(subject.page).to eq(page) }
        it { expect(subject.per).to eq(default_per) }
      end

      context 'when per is less than 1' do
        let(:per) { -1 }

        it { expect(subject.page).to eq(page) }
        it { expect(subject.per).to eq(default_per) }
      end

      context 'when per is not included in per_variants' do
        let(:per) { 23 }

        it { expect(subject.page).to eq(page) }
        it { expect(subject.per).to eq(default_per) }
      end
    end
  end
end
