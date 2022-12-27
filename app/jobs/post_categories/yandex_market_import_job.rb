# frozen_string_literal: true

module PostCategories
  class YandexMarketImportJob < ApplicationJob
    def perform(realm, url)
      connection = Faraday.new(url: url) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.response :follow_redirects
      end
      response = connection.get(url)
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
      nil
    end
  end
end
