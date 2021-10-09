Realm.find_each do |realm|
  SitemapGenerator::Sitemap.default_host = "https://#{realm.domain}"
  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{realm.domain}"
  SitemapGenerator::Sitemap.create do
    realm.posts.find_each do |post|
      add articles_url(article: post, host: realm.domain), lastmod: post.updated_at
    end

    SitemapGenerator::Sitemap.ping_search_engines
    # The official docs says: "Not needed if you use the rake tasks"
    # But I see pinging only on last website. So I added this line.
    # There is some drawbacks. It seems that last domain pinging twice.
    # TODO: check this.
  end
end