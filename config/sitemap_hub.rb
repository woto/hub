# frozen_string_literal: true

sitemap = SitemapGenerator::LinkSet.new

sitemap.default_host = root_url(host: ENV['DOMAIN_NAME'], protocol: 'https')
sitemap.sitemaps_path = File.join('sitemaps')
sitemap.create do
  Entity.find_each do |entity|
    add(entity_path(entity, locale: nil), {
          lastmod: entity.updated_at,
          alternate: I18n.available_locales.map do |locale|
                       { hreflang: locale, href: entity_url(entity, locale: locale, host: ENV['DOMAIN_NAME'], protocol: 'https') }
                     end
        })
  end

  Mention.find_each do |mention|
    add(mention_path(mention, locale: nil), {
          lastmod: mention.updated_at,
          alternate: I18n.available_locales.map do |locale|
                       { hreflang: locale, href: mention_url(mention, locale: locale, host: ENV['DOMAIN_NAME'], protocol: 'https') }
                     end
        })
  end

  # sitemap.ping_search_engines
  # # The official docs says: "Not needed if you use the rake tasks"
  # # But I see pinging only on last website. So I added this line.
  # # There is some drawbacks. It seems that last domain pinging twice.
  # # TODO: check this.
end
