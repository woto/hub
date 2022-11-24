# frozen_string_literal: true

SitemapGenerator::Sitemap.default_host = root_url(host: ENV.fetch('DOMAIN_NAME'), protocol: 'https')
SitemapGenerator::Sitemap.sitemaps_path = File.join('sitemaps')

SitemapGenerator::Sitemap.create do
  Entity.find_each do |entity|
    add(entity_path(entity, locale: nil), {
          lastmod: entity.updated_at,
          alternate: I18n.available_locales.map do |locale|
            href = entity_url(entity, locale:, host: ENV.fetch('DOMAIN_NAME'), protocol: 'https')
            { lang: locale, href: }
          end
        })
  end

  # sitemap.ping_search_engines
  # # The official docs says: "Not needed if you use the rake tasks"
  # # But I see pinging only on last website. So I added this line.
  # # There is some drawbacks. It seems that last domain pinging twice.
  # # TODO: check this.
end
