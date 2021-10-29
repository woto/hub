# frozen_string_literal: true

require 'rails_helper'

describe PostCategories::GoogleMerchantImportJob, type: :job do
  subject do
    described_class.perform_now(create(:realm),
                                'https://www.google.com/basepages/producttype/taxonomy-with-ids.ru-RU.xls')
  end

  before do
    stub_request(:get, 'https://www.google.com/basepages/producttype/taxonomy-with-ids.ru-RU.xls')
      .to_return(status: 200, body: file_fixture('taxonomy-with-ids.ru-RU.xls'))
  end

  it 'correctly imports post_categories' do
    expect { subject }.to change(PostCategory, :count).by(6)

    expect(PostCategory.last.path.map(&:title)).to(
      eq(['Багаж и сумки', 'Багажные принадлежности', 'Дорожные бутылки и контейнеры'])
    )
  end
end
