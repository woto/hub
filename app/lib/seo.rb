# frozen_string_literal: true

class Seo
  NoFollow = 'nofollow'
  NoReferrer = 'noreferrer'
  UGC = 'ugc'

  attr_accessor :controller, :noindex, :title

  def initialize(controller)
    @controller = controller
    @meta = []
  end

  def noindex!
    @meta << ApplicationController.helpers.tag(:meta, { name: 'robots', content: 'noindex' })
    controller.response.headers['X-Robots-Tag'] = 'noindex'
  end

  def title!(title)
    @title = title
    @meta << ApplicationController.helpers.tag.title("GoodReviews.ru | #{title}")
  end

  def langs!
    keys = I18n.available_locales.map { |locale| { lang: locale, locale: locale } }
    keys << { lang: 'x-default', locale: nil }

    keys.each do |lang:, locale:|
      @meta << ApplicationController.helpers.tag(:link, rel: 'alternate', href: yield(locale), hreflang: lang)
    end
  end

  def canonical!(href)
    @meta << ApplicationController.helpers.tag(:link, rel: 'canonical', href: href)
  end

  def tags
    ApplicationController.helpers.raw(@meta.join("\n"))
  end
end
