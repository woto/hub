require 'rails_helper'

xdescribe 'Offers page', type: :system do
  let!(:feed) { create(:feed, xml_file_path: file_fixture('feeds/yml-simplified.xml')) }

  before do
    Feeds::Parse.call(feed: feed)
    Elastic::RefreshOffersIndexInteractor.call
  end

  it 'imports feed and searches offers' do
    visit offers_path(q: 'Мороженица', locale: 'ru')
    expect(page).to have_css('.item_offer', count: 2)
  end
end
