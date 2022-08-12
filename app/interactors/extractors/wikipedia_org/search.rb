# frozen_string_literal: true

module Extractors
  module WikipediaOrg
    class Search
      include ApplicationInteractor
      include Rails.application.routes.url_helpers

      def call
        result = Wikipedia.find(context.q)
        context.object = {
          title: result.title,
          fullurl: result.fullurl,
          text: result.text,
          content: result.content,
          summary: result.summary,
          categories: result.categories,
          links: result.links,
          extlinks: result.extlinks,
          images: result.images,
          image_urls: result.image_urls,
          image_thumburls: result.image_thumburls,
          image_descriptionurls: result.image_descriptionurls,
          main_image_url: result.main_image_url
        }
      end
    end
  end
end

