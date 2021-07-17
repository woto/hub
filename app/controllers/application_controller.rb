# frozen_string_literal: true

# Absolutely all application controllers should inherit from this class!
class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from Pundit::NotAuthorizedError, with: :render_403

  impersonates :user

  # NOTE: Seems not needed due to the customizations in devise.rb
  #
  # respond_to :html, :json

  include Pundit
  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index

  around_action :set_time_zone
  before_action :detect_device_format
  before_action :authenticate_user!
  before_action :set_responsible

  helper_method :path_for_switch_language
  helper_method :url_for_search_everywhere

  private

  def render_404(exception)
    Rails.logger.error(exception.message)
    Yabeda.hub.http_errors.increment({ http_code: 404 }, by: 1)

    respond_to do |format|
      format.html { render file: Rails.root.join('public/404.html'), layout: false, status: :not_found }
    end
  end

  def render_403(exception)
    Rails.logger.error(exception.message)
    Yabeda.hub.http_errors.increment({ http_code: 403 }, by: 1)

    respond_to do |format|
      format.html { render file: Rails.root.join('public/404.html'), layout: false, status: :forbidden }
    end
  end

  def default_url_options
    # NOTE: if realm is set we do not want to add locale params to the links, because locale info "stored" in domain
    return {} if Current.realm

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
    Current.responsible = true_user
  end

  def path_for_switch_language(_locale)
    nil
  end

  def url_for_search_everywhere
    url_for(request.params.slice(:order, :per, :sort, :cols).merge(action: :index, only_path: false))
  end
end
