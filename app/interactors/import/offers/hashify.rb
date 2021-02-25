# frozen_string_literal: true

module Import
  module Offers
    HASH_BANG_KEY = '#'
    SELF_NAME_KEY = '*'
    SKIPPED_TAGS = ['delivery-options'].freeze

    class Hashify
      def self.call(doc)
        # TODO: Make special class? It could be hard to understand
        # in other tests that offer hash has default settings.
        offer = Hash.new { |hash, key| hash[key] = [] }
        offer[SELF_NAME_KEY] = doc.to_h

        # append attributes if any
        doc.elements.each do |child|
          next if child.name.in?(SKIPPED_TAGS)

          offer[child.name] << hashify(child)
        end
        offer
      end

      def self.hashify(child)
        hsh = GlobalHelper.hashify(child)

        raise Feeds::Process::ElasticUnexpectedNestingError, child.to_s unless child.elements.empty?

        # TODO: May be should use simple format? What about XSS?
        raise Feeds::Process::ElasticUnexpectedNestingError, child.to_s if child.children.reject(&:text?).size > 1

        hsh
      end
    end
  end
end
