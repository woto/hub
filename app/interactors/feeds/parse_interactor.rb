# frozen_string_literal: true

module Feeds
  class ParseInteractor
    include ApplicationInteractor

    BULK_THRESHOLD = 1_000
    OFFERS_LIMIT = 500_000

    def call
      Nokogiri::XML.Reader(File.open(context.feed.xml_file_path)).each do |node|
        case node.node_type
        # Open tag
        when Nokogiri::XML::Reader::TYPE_ELEMENT
          case node.name
          when 'offer'
            offer_open(node)
          when 'offers'
            offers_open
          when 'category'
            category_open(node)
          when 'categories'
            categories_open
          end
        # Close tag
        when Nokogiri::XML::Reader::TYPE_END_ELEMENT
          case node.name
          when 'categories'
            categories_close
          when 'offers'
            offers_close
          end
        end
      end
    end

    private

    def categories_open
      @categories = Import::CategoriesCreatorInteractor.new(feed: context.feed)
    end

    def offers_open
      Import::Categories::BindParentsInteractor.call(feed: context.feed)
      @offers = Feeds::OffersInteractor.new(feed: context.feed)
    end

    def categories_close
      @categories.flush
    end

    def offers_close
      finish_processing
    end

    def offer_open(node)
      doc = Nokogiri::XML(node.outer_xml).children.first

      @offers.append(doc)
      @offers.flush if @offers.batch_count == BULK_THRESHOLD

      return unless @offers.total_count == OFFERS_LIMIT

      finish_processing
      raise Import::ProcessInteractor::OffersLimitError
    end

    def category_open(node)
      doc = Nokogiri::XML(node.outer_xml).children.first

      @categories.append(doc)
    end

    def finish_processing
      @offers.flush

      context.feed.update!(
        operation: 'success',
        categories_count: @categories&.total_count || 0,
        offers_count: @offers&.total_count || 0,
        succeeded_at: Time.current
      )
    end
  end
end
