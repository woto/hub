# frozen_string_literal: true

# class comment
class ApplicationController < ActionController::Base
  #protect_from_forgery unless: -> { request.format.json? }
  #skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  #include Pundit
  #
  #after_action :verify_authorized, except: :index
  #after_action :verify_policy_scoped, only: :index

  # https://github.com/doorkeeper-gem/doorkeeper/wiki/Running-Doorkeeper-with-Devise
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # https://github.com/doorkeeper-gem/doorkeeper/wiki/Running-Doorkeeper-with-Devise
  def current_user
    current_resource_owner
  end
end
