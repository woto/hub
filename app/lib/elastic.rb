# Main class for Elastic Search
class Elastic
  # Name picker for index
  module IndexName
    class << self
      def all_categories
        picker('*', 'categories')
      end

      def all_offers
        picker('*', 'offers')
      end

      def offers(name)
        picker(name, 'offers')
      end

      def categories(name)
        picker(name, 'categories')
      end

      def offers_crop(name)
        cropper(name, 'offers')
      end

      private

      def picker(name, suffix)
        "#{name}.#{Rails.env}.#{suffix}"
      end

      def cropper(name, suffix)
        name.chomp!(".#{Rails.env}.#{suffix}")
      end
    end
  end

  class << self
    def call(params)
      @params = params
      client = Elasticsearch::Client.new Rails.application.config.elastic

      page, per = PaginateRule.call(@params)
      request = search_request.merge(
        from: (page - 1) * per,
        size: per
      )

      result = client.search(request)
      offers = result['hits']['hits']

      result = client.count(search_request)
      count = result['count']

      [offers, count]
    end

    def search_request
      {
        index: ::Elastic::IndexName.offers(@params[:feed_id] || '*'),
        body: {
          query: {
            query_string: {
              query: @params[:q].presence || '*'
            }
          }
        }
      }
    end
  end
end
