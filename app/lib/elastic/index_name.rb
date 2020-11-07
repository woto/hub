# frozen_string_literal: true

module Elastic
  class IndexName
    class << self

      # TODO! conceive new mask. It is high probability that this mask will overlap with any unexpected index
      def wildcard
        "*#{Rails.env}.*"
      end

      def crop_environment(index_name)
        index_name.delete_prefix("#{Rails.env}.")
      end


      def all_offers
        picker('*', 'offers')
      end

      def offers
        new_picker('offers')
      end

      def offers_crop(name)
        cropper(name, 'offers')
      end

      private

      def new_picker(name)
        "#{Rails.env}.#{name}"
      end

      def picker(name, suffix)
        "#{name}.#{Rails.env}.#{suffix}"
      end

      def cropper(name, suffix)
        name.chomp!(".#{Rails.env}.#{suffix}")
      end
    end
  end
end
