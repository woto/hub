# frozen_string_literal: true

module Ext
  module Admitad
    module Api
      module Campaigns
        class ParseFeed
          include ApplicationInteractor

          BULK_THRESHOLD = 1000
          OFFERS_LIMIT = 20000

          def call
            Rails.logger.info('Ext::Admitad::Api::Campaigns::ParseFeed')
            path = context.feed.file_full_path

            Nokogiri::XML.Reader(File.open(path)).each do |node|
              case node.node_type
              # Open tag
              when Nokogiri::XML::Reader::TYPE_ELEMENT
                if node.name == 'offer'
                  offer_open(node)
                elsif node.name == 'offers'
                  offers_open
                elsif node.name == 'category'
                  category_open(node)
                elsif node.name == 'categories'
                  categories_open
                end
              # Close tag
              when Nokogiri::XML::Reader::TYPE_END_ELEMENT
                if node.name == 'categories'
                  categories_close
                elsif node.name == 'offers'
                  offers_close
                end
              end
            end
          end

          private

          def categories_open
            @categories_counter = 0
          end

          def offers_open
            @offers_counter = 0
            @offers = Offers.new(context)
          end

          def categories_close
            Ext::Admitad::Api::Campaigns::OrganizeCategories.call(context)
            @categories = FeedCategory.where(feed: context.feed).arrange_serializable
          end

          def offers_close
            finish_processing
          end

          def offer_open(node)
            @offers_counter += 1
            doc = Nokogiri::XML(node.outer_xml).children.first

            @offers.append(doc)
            @offers.flush if @offers.size == BULK_THRESHOLD

            if @offers_counter == OFFERS_LIMIT
              finish_processing
              raise Ext::Admitad::Api::Campaigns::Processing::SkipJobError
            end
          end

          def category_open(node)
            @categories_counter += 1
            doc = Nokogiri::XML(node.outer_xml).children.first

            fc = FeedCategory.where(
              feed: context.feed,
              ext_id: doc.attributes['id'].value
            ).first_or_initialize

            fc.update!(
              last_attempt_uuid: context.feed.last_attempt_uuid,
              ext_parent_id: doc.attributes['parentId']&.value,
              data: doc.to_s,
              name: doc.text
            )
          end

          def finish_processing
            @offers.flush

            context.feed.update!(
              categories_count: @categories_counter,
              offers_count: @offers_counter,
              last_succeeded_at: Time.current
            )
          end
        end
      end
    end
  end
end
