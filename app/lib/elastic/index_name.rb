# frozen_string_literal: true

module Elastic
  class IndexName
    class << self

      def all_offers
        picker('*', 'offers')
      end

      def offers(name)
        picker(name, 'offers')
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
