# frozen_string_literal: true

Realm.find_each do |realm|
  sitemap = SitemapGenerator::LinkSet.new
  sitemap.default_host = root_url(host: realm.domain, protocol: 'https')
  sitemap.sitemaps_path = File.join('sitemaps', realm.domain)
  sitemap.create do
    realm.posts.find_each do |post|
      add article_path(id: post.id, locale: nil), lastmod: post.updated_at
    end

    # sitemap::Sitemap.ping_search_engines
    # # The official docs says: "Not needed if you use the rake tasks"
    # # But I see pinging only on last website. So I added this line.
    # # There is some drawbacks. It seems that last domain pinging twice.
    # # TODO: check this.
  end
end
