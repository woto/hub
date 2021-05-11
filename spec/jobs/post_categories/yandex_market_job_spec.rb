# frozen_string_literal: true

require 'rails_helper'

describe PostCategories::YandexMarketJob, type: :job do
  subject { described_class.perform_now }

  before do
    stub_request(:get, 'http://download.cdn.yandex.net/market/market_categories.xls')
      .to_return(status: 200, body: file_fixture('market_categories.xls'))
  end

  it 'correctly imports post_categories' do
    expect { subject }.to change(PostCategory, :count).by(6)

    expect(PostCategory.last.path.map(&:title)).to(
      eq(['Авто', 'Автомобильные инструменты', 'Прочие инструменты'])
    )
  end

  it 'creates one realm' do
    expect { subject }.to change(Realm, :count).by(1)

    expect(Realm.last).to have_attributes(
      kind: 'post',
      locale: 'ru',
      domain: 'yandex',
      title: 'Яндекс Маркет'
    )
  end
end
