# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mentions::ScrapperJob, type: :job do
  subject { described_class.perform_now(mention_id: mention.id, mention_url: mention.url, user_id: user.id) }

  let(:user) { create(:user) }
  let(:mention) { create(:mention, url: 'https://example.com/?fake') }

  context 'when 200 response code' do
    it 'successfully stores image' do
      url = 'http://scrapper:4000/screenshot?url=https://example.com/?fake'
      stub_request(:get, url).to_return(
        status: 200,
        body: { image: Base64Helpers.image }.to_json
      )

      expect { subject }
        .to change(Image, :count)
        .and(change { mention.reload.image })

      expect(Image.last.user).to eq(user)
      expect(ImagesRelation.last.user).to eq(user)
    end
  end

  context 'when 403 response code' do
    it 'raises exception' do
      url = 'http://scrapper:4000/screenshot?url=https://example.com/?fake'
      stub_request(:get, url).to_return(status: 403)

      expect { subject }.to raise_exception(RuntimeError, 'the server responded with status 403')
    end
  end
end
