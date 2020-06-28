#

# Absolutely all application controllers should inherit from this class!
class ApplicationController < ActionController::Base
  respond_to :html, :json

  around_action :switch_locale
  before_action :authenticate_user!

  private

  # Locale switching copied from official Rails Guides without any modifications
  # This makes me happy :)

  def switch_locale(&action)
    locale = extract_locale_from_subdomain || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def extract_locale_from_subdomain
    parsed_locale = request.subdomains.first || params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def default_url_options
    { locale: I18n.locale }
  end

end
