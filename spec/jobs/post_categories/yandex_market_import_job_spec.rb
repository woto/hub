# frozen_string_literal: true

require 'rails_helper'

describe PostCategories::YandexMarketImportJob, type: :job do
  subject do
    described_class.perform_now(create(:realm), 'https://download.cdn.yandex.net/market/market_categories.xls')
  end

  before do
    stub_request(:get, 'https://download.cdn.yandex.net/market/market_categories.xls')
      .to_return(status: 200, body: file_fixture('market_categories.xls'))
  end

  it 'correctly imports post_categories' do
    expect { subject }.to change(PostCategory, :count).by(6)

    expect(PostCategory.last.path.map(&:title)).to(
      eq(['Авто', 'Автомобильные инструменты', 'Прочие инструменты'])
    )
  end
end
