# frozen_string_literal: true

class Feed::File
  def initialize(feed)
    @feed = feed
  end

  def path
    [base_name, '.file'].join
  end

  def dir
    [base_name, '.dir'].join
  end

  def zip?
    @feed.downloaded_file_type.include?('zip')
  end

  private

  def base_name
    Rails.root.join(Rails.configuration.feeds_path, @feed.slug_with_advertiser)
  end
end
