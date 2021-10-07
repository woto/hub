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

  def confirmed_at
    decorate_datetime(super)
  end

  def posts_count
    string = h.t(:posts_count, count: super)
    h.link_to(string, h.posts_path(filters: { user_id: { min: _id, max: _id } }))
  end
end
