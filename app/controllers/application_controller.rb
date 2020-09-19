# frozen_string_literal: true

# Absolutely all application controllers should inherit from this class!
class ApplicationController < ActionController::Base
  respond_to :html, :json

  include Pundit

  around_action :switch_locale
  around_action :set_time_zone
  before_action :detect_device_format
  before_action :authenticate_user!

  private

  # Locale switching copied from official Rails Guides without any modifications
  # This makes me happy :)

  # Locale

  def switch_locale(&action)
    locale = extract_locale_from_subdomain || I18n.default_locale
    locale = locale.to_s
    session[:locale] = locale
    I18n.with_locale(locale, &action)
  end

  def extract_locale_from_subdomain
    parsed_locale = request.subdomains.reject { |lng| lng == 'www' }.first
    parsed_locale ||= params[:locale]
    parsed_locale ||= session[:locale]
    parsed_locale ||= request.headers['Accept-Language'].split(',').first
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  rescue StandardError
    nil
  end

  def default_url_options
    { locale: I18n.locale }
  end

  # Time zone

  def set_time_zone
    Time.use_zone(current_user&.profile&.time_zone) { yield }
  end

  def detect_device_format
    case request.user_agent
    when /iPad/i
      request.variant = :tablet
    when /iPhone/i
      request.variant = :phone
    when /Android/i && /mobile/i
      request.variant = :phone
    when /Android/i
      request.variant = :tablet
    when /Windows Phone/i
      request.variant = :phone
    end
  end
end
