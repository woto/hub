# frozen_string_literal: true

module Elastic
  class IndexName
    class << self

      def wildcard
        "#{Rails.env}.*"
      end

      def crop_environment(index_name)
        index_name.delete_prefix("#{Rails.env}.")
      end


      def all_offers
        picker('*', 'offers')
      end

      def news
        new_picker('news')
      end

      def offers
        new_picker('offers')
      end

      def feed_categories
        new_picker('feed_categories')
      end

      def post_categories
        new_picker('post_categories')
      end

      def feeds
        new_picker('feeds')
      end

      def posts
        new_picker('posts')
      end

      def accounts
        new_picker('accounts')
      end

      def checks
        new_picker('checks')
      end

      def favorites
        new_picker('favorites')
      end

      def transactions
        new_picker('transactions')
      end

      def users
        new_picker('users')
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
