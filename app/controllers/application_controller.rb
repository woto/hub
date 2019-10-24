# frozen_string_literal: true

# Absolutely all application controllers should inherit from this class!
class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  around_action :switch_locale

  private

  # Locale switching copied from official Rails Guides without any modifications
  # This makes me happy :)

  def switch_locale(&action)
    locale = extract_locale_from_subdomain || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def extract_locale_from_subdomain
    parsed_locale = request.subdomains.first
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
end
