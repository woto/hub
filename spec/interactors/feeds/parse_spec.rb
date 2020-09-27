require 'rails_helper'

RSpec.describe Feeds::Parse do
  let(:feed) { create(:feed, :with_attempt_uuid, xml_file_path: file_fixture("feeds/yml-simplified.xml")) }

  it 'does not raise error' do
    Feeds::Parse.call(feed: feed)
  end
end
