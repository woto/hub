# frozen_string_literal: true

module ImageHash
  extend ActiveSupport::Concern

  included do
    def image_hash
      empty_image = {
        '50' => ApplicationController.helpers.asset_pack_path('media/images/icon-404-50.png'),
        '100' => ApplicationController.helpers.asset_pack_path('media/images/icon-404-100.png'),
        '200' => ApplicationController.helpers.asset_pack_path('media/images/icon-404-100.png'),
        '300' => ApplicationController.helpers.asset_pack_path('media/images/icon-404-100.png'),
        '500' => ApplicationController.helpers.asset_pack_path('media/images/icon-404-100.png'),
        '1000' => ApplicationController.helpers.asset_pack_path('media/images/icon-404-100.png')
      }

      {
        original: image ? image_url : empty_image['50'],
        thumbnails: {
          '50' => image ? image.derivation_url(:thumbnail, 50, 50) : empty_image['50'],
          '100' => image ? image.derivation_url(:thumbnail, 100, 100) : empty_image['100'],
          '200' => image ? image.derivation_url(:thumbnail, 200, 200) : empty_image['200'],
          '300' => image ? image.derivation_url(:thumbnail, 300, 300) : empty_image['300'],
          '500' => image ? image.derivation_url(:thumbnail, 500, 500) : empty_image['500'],
          '1000' => image ? image.derivation_url(:thumbnail, 1000, 1000) : empty_image['1000']
        },
        width: image ? image.metadata['width'] : 50,
        height: image ? image.metadata['height'] : 50
      }
    end
  end
end