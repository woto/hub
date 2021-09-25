# frozen_string_literal: true

class FeedDecorator < ApplicationDecorator
  def synced_at
    decorate_datetime(super)
  end

  def succeeded_at
    decorate_datetime(super)
  end

  def processing_started_at
    decorate_datetime(super)
  end

  def processing_finished_at
    decorate_datetime(super)
  end

  def network_updated_at
    decorate_datetime(super)
  end

  def advertiser_synced_at
    decorate_datetime(super)
  end

  def advertiser_created_at
    decorate_datetime(super)
  end

  def advertiser_updated_at
    decorate_datetime(super)
  end

  def error_text
    decorate_text(super)
  end

  def raw
    decorate_text(super)
  end

  def advertiser_raw
    decorate_text(super)
  end

  def url
    helpers.link_to(helpers.t('link'), super)
  end

  def advertiser_name
    helpers.link_to(super, helpers.advertiser_offers_path(advertiser_id: object['_source']['advertiser_id']))
  end

  def advertiser_picture
    helpers.link_to(helpers.advertiser_offers_path(advertiser_id: object['_source']['advertiser_id'])) do
      super.html_safe if super.present?
    end
  end

  def name
    helpers.link_to(super, helpers.feed_offers_path(feed_id: object['_source']['id']))
  end

  def is_active
    helpers.t(super)
  end

  def advertiser_is_active
    helpers.t(super)
  end

  def operation()
    helpers.t(super)
  end

  def downloaded_file_size
    helpers.number_to_human_size(super)
  end
end
