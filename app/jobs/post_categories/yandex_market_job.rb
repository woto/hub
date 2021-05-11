# frozen_string_literal: true

module PostCategories
  class YandexMarketJob < ApplicationJob
    queue_as :default

    URL = 'http://download.cdn.yandex.net/market/market_categories.xls'

    def perform(*_args)
      connection = Faraday.new(url: URL) do |faraday|
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.adapter Faraday.default_adapter
      end
      response = connection.get(URL)
      # TODO: how to skip step with converting string to io?
      io = StringIO.new(response.body)
      open_book = Spreadsheet.open(io)
      sheet = open_book.worksheet(0)
      sheet.each do |row|
        *paths = row.join.split('/')
        scope = nil
        paths.each do |path|
          next if path == 'Все товары'

          created = (scope&.children || PostCategory).find_or_create_by!(title: path, realm: realm)
          scope = created
        end
      end

      # PostCategory.__elasticsearch__.create_index!
      # PostCategory.__elasticsearch__.import
      nil
    end

    private

    def realm
      Realm.pick(kind: :post, locale: 'ru', domain: 'yandex', title: 'Яндекс Маркет')
    end
  end
end
