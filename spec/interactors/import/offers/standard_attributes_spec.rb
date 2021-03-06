# frozen_string_literal: true

require 'rails_helper'

describe Import::Offers::StandardAttributes do
  subject { described_class.call(offer, feed) }

  let(:feed) { create(:feed) }
  let(:offer) { {} }

  it 'sets feed attempt_uuid to offer hash' do
    freeze_time do
      subject
      expect(offer).to include('attempt_uuid' => feed.attempt_uuid,
                               'indexed_at' => Time.current)
    end
  end
end
