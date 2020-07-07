# frozen_string_literal: true

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
end
