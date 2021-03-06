# frozen_string_literal: true

module Elastic
  class IndexName
    class << self

      def wildcard
        "#{Rails.env}.*"
      end

      def tokenizer
        pick('tokenizer')
      end

      def news
        pick('news')
      end

      def offers
        pick('offers')
      end

      def feed_categories
        pick('feed_categories')
      end

      def post_categories
        pick('post_categories')
      end

      def feeds
        pick('feeds')
      end

      def posts
        pick('posts')
      end

      def accounts
        pick('accounts')
      end

      def checks
        pick('checks')
      end

      def favorites
        pick('favorites')
      end

      def transactions
        pick('transactions')
      end

      def users
        pick('users')
      end

      def pick(name)
        "#{Rails.env}.#{name}"
      end
    end
  end
end
