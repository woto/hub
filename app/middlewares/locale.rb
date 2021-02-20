# frozen_string_literal: true

# NOTE: this is slightly modified version of
# https://github.com/rack/rack-contrib/blob/master/lib/rack/contrib/locale.rb
#
require 'i18n'

class Locale
  def initialize(app)
    @app = app
  end

  def call(env)
    locale = locale_from_domain(env['HTTP_HOST'])
    locale ||= locale_from_path(env['PATH_INFO'])
    locale ||= locale_from_cookie(env['HTTP_COOKIE'])
    locale ||= user_preferred_locale(env['HTTP_ACCEPT_LANGUAGE'])
    locale ||= I18n.default_locale

    locale_string = locale.to_s
    status = nil
    headers = nil
    body = nil

    I18n.with_locale(locale_string) do
      status, headers, body = @app.call(env)
    end

    headers = Rack::Utils::HeaderHash.new(headers)
    headers['Content-Language'] = locale_string unless headers['Content-Language']
    Rack::Utils.set_cookie_header!(headers, 'locale', { value: locale_string, path: '/' })

    [status, headers, body]
  end

  private

  def locale_from_path(path)
    locale = path.split('/').reject(&:blank?).first
    locale if I18n.available_locales.find { |al| match?(al, locale) }
  end

  def locale_from_domain(host)
    locale = host.sub(/:\d+$/, '').split('.').first
    locale if I18n.available_locales.find { |al| match?(al, locale) }
  end

  def locale_from_cookie(cookie)
    locale = Rack::Utils.parse_cookies_header(cookie)['locale']
    locale if I18n.available_locales.find { |al| match?(al, locale) }
  end

  # Accept-Language header is covered mainly by RFC 7231
  # https://tools.ietf.org/html/rfc7231
  #
  # Related sections:
  #
  # * https://tools.ietf.org/html/rfc7231#section-5.3.1
  # * https://tools.ietf.org/html/rfc7231#section-5.3.5
  # * https://tools.ietf.org/html/rfc4647#section-3.4
  #
  # There is an obsolete RFC 2616 (https://tools.ietf.org/html/rfc2616)
  #
  # Edge cases:
  #
  # * Value can be a comma separated list with optional whitespaces:
  #   Accept-Language: da, en-gb;q=0.8, en;q=0.7
  #
  # * Quality value can contain optional whitespaces as well:
  #   Accept-Language: ru-UA, ru; q=0.8, uk; q=0.6, en-US; q=0.4, en; q=0.2
  #
  # * Quality prefix 'q=' can be in upper case (Q=)
  #
  # * Ignore case when match locale with I18n available locales
  #
  def user_preferred_locale(header)
    return if header.nil?

    locales = header.gsub(/\s+/, '').split(',').map do |language_tag|
      locale, quality = language_tag.split(/;q=/i)
      quality = quality ? quality.to_f : 1.0
      [locale, quality]
    end.reject do |(locale, quality)|
      locale == '*' || quality.zero?
    end.sort_by do |(_, quality)|
      quality
    end.map(&:first)

    return if locales.empty?

    if I18n.enforce_available_locales
      locale = locales.reverse.find { |locale| I18n.available_locales.any? { |al| match?(al, locale) } }
      I18n.available_locales.find { |al| match?(al, locale) } if locale
    else
      locales.last
    end
  end

  def match?(s1, s2)
    s1.to_s.casecmp(s2.to_s).zero?
  end
end
