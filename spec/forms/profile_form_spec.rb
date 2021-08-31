# frozen_string_literal: true

require 'rails_helper'

describe ProfileForm do
  subject { described_class.new(params) }

  describe '#languages' do
    context 'when languages is in the configuration array' do
      let(:params) { { languages: Rails.application.config.global[:locales].pluck(:locale).sample(3) } }

      it 'does not include error' do
        subject.valid?
        expect(subject.errors.include?(:languages)).to be_falsey
      end
    end

    context 'when languages is not in the configuration array' do
      let(:params) { { languages: %w[xx en] } }

      it 'includes errors' do
        subject.valid?
        expect(subject.errors.include?(:languages)).to be_truthy
      end
    end
  end
end
