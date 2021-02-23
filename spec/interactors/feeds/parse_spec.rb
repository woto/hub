# frozen_string_literal: true

require 'rails_helper'

describe Feeds::Parse do
  let(:feed) { create(:feed, :with_attempt_uuid, xml_file_path: file_fixture('feeds/yml-simplified.xml')) }

  it 'does not raise error' do
    described_class.call(feed: feed)
  end
end
