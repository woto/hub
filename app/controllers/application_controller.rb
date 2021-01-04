# frozen_string_literal: true

# Absolutely all application controllers should inherit from this class!
class ApplicationController < ActionController::Base
  impersonates :user

  respond_to :html, :json

  include Pundit

  around_action :set_time_zone
  before_action :detect_device_format
  before_action :authenticate_user!
  before_action :set_responsible

  helper_method :path_for_switch_language

  helper_method :url_for_search_everywhere

  private

  def default_url_options
    return {} if I18n.available_locales.map(&:to_s).include?(request.subdomains.first)

    { locale: I18n.locale }
  end

  # Time zone

  def set_time_zone(&block)
    Time.use_zone(current_user&.profile&.time_zone, &block)
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

  def set_responsible
    Current.responsible = current_user
  end

  def path_for_switch_language(_locale)
    nil
  end

  def url_for_search_everywhere
    url_for(request.params.slice(:order, :per, :sort, :cols).merge(action: :index, only_path: false))
  end
end
