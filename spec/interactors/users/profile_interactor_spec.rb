# frozen_string_literal: true

require 'rails_helper'

describe Users::ProfileInteractor do
  subject(:interactor) { described_class.call(params:, current_user: user) }

  let(:user) { create(:user) }

  describe 'name' do
    context 'when name is nil' do
      let(:params) { build(:profile_params, name: nil) }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when name is empty string' do
      let(:params) { build(:profile_params, name: '') }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe 'bio' do
    context 'when bio is nil' do
      let(:params) { build(:profile_params, bio: nil) }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when bio is empty string' do
      let(:params) { build(:profile_params, bio: '') }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe 'languages' do
    context 'when languages is nil' do
      let(:params) { build(:profile_params, languages: nil) }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when languages is empty array' do
      let(:params) { build(:profile_params, languages: []) }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when languages is not in the configuration array' do
      let(:params) { build(:profile_params, languages: %w[xx yy]) }

      it 'raises error' do
        expect { subject }.to raise_error(
          StandardError, {
            params: {
              languages: { '0': ['must be one of: en, ru'], '1': ['must be one of: en, ru'] }
            }
          }.to_json
        )
      end
    end

    context 'when languages is in the configuration array' do
      let(:params) { build(:profile_params, languages: ['en']) }

      it 'does not include error' do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe 'time_zone' do
    context 'when time_zone is nil' do
      let(:params) { build(:profile_params, time_zone: nil) }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when time_zone is empty string' do
      let(:params) { build(:profile_params, time_zone: '') }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when time_zone is not in the allowed list' do
      let(:params) { build(:profile_params, time_zone: 'zz') }

      it 'raises error' do
        expect { subject }.to raise_error(
          StandardError, {
            params: {
              time_zone: ["must be one of: #{ActiveSupport::TimeZone.all.map(&:name).join(', ')}"]
            }
          }.to_json
        )
      end
    end

    context 'when time_zone is in the allowed list' do
      let(:params) { build(:profile_params, time_zone: 'Moscow') }

      it 'does not include error' do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe 'messengers' do
    context 'when messengers is nil' do
      let(:params) { build(:profile_params, messengers: nil) }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when messengers is empty array' do
      let(:params) { build(:profile_params, messengers: []) }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when messenger is array with one empty object' do
      let(:params) { build(:profile_params, messengers: [{}]) }

      it 'raises error' do
        expect { subject }.to raise_error(
          StandardError, {
            params: {
              messengers: {
                '0': { type: ['is missing'], value: ['is missing'] }
              }
            }
          }.to_json
        )
      end
    end

    context 'when messenger type is not valid' do
      let(:params) { build(:profile_params, messengers: [{ type: 'zz', value: 'value' }]) }

      it 'raises error' do
        expect { subject }.to raise_error(
          StandardError, {
            params: {
              messengers: {
                '0': { type: ["must be one of: #{
                  Rails.application.config.global[:messengers].map { |messenger| messenger[:long] }.join(', ')}"] }
              }
            }
          }.to_json
        )
      end
    end

    context 'when messenger value is nil' do
      let(:params) { build(:profile_params, messengers: [{ type: 'Telegram', value: nil }]) }

      it 'does not raise error' do
        expect { subject }.to raise_error(
          StandardError, {
            params: {
              messengers: {
                '0': { value: ['must be a string'] }
              }
            }
          }.to_json
        )
      end
    end

    context 'when messenger value is empty string' do
      let(:params) { build(:profile_params, messengers: [{ type: 'Telegram', value: '' }]) }

      it 'does not raise error' do
        expect { subject }.to raise_error(
          StandardError, {
            params: {
              messengers: { '0': { value: ['must be filled'] } }
            }
          }.to_json
        )
      end
    end

    context 'when messengers is valid' do
      let(:params) { build(:profile_params, messengers: [{ type: 'Telegram', value: '+7 (999) 999-99-99' }]) }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe 'avatar' do
    context 'when avatar is nil' do
      let(:params) { build(:profile_params, avatar: nil) }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when avatar is uploaded image' do
      let(:params) { build(:profile_params, avatar: { data: ShrineImage.image_data }) }

      it 'does not raise error' do
        expect { subject }.not_to raise_error
      end
    end

  end
end
