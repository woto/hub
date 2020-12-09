# frozen_string_literal: true

class UserDecorator < ApplicationDecorator

  def profile_updated_at
    decorate_datetime(super)
  end

  def profile_created_at
    decorate_datetime(super)
  end

  def reset_password_sent_at
    decorate_datetime(super)
  end

  def remember_created_at
    decorate_datetime(super)
  end

  def last_sign_in_at
    decorate_datetime(super)
  end

  def current_sign_in_at
    decorate_datetime(super)
  end

  def confirmation_sent_at
    decorate_datetime(super)
  end
end
