class RobotsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render plain: <<~HERE
      Sitemap: #{File.join(root_url(locale: nil), 'sitemaps', Current.realm&.domain.to_s, 'sitemap.xml.gz')}
    HERE
  end
end
