# frozen_string_literal: true

class UserDecorator < ApplicationDecorator

  def updated_at
    decorate_datetime(__method__)
  end

  def profile_updated_at
    decorate_datetime(__method__)
  end

  def profile_created_at
    decorate_datetime(__method__)
  end

  def reset_password_sent_at
    decorate_datetime(__method__)
  end

  def remember_created_at
    decorate_datetime(__method__)
  end

  def last_sign_in_at
    decorate_datetime(__method__)
  end

  def current_sign_in_at
    decorate_datetime(__method__)
  end

  def confirmation_sent_at
    decorate_datetime(__method__)
  end


end
