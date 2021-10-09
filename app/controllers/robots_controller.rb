class RobotsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render plain: <<~HERE
      Sitemap: #{File.join(root_url, 'sitemaps', Current.realm.domain, 'sitemap.xml.gz')}
    HERE
  end
end
