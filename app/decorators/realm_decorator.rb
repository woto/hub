# frozen_string_literal: true

class RealmDecorator < ApplicationDecorator
  def domain
    h.link_to(super, h.realm_path(id: _id))
  end

  def posts_count
    string = h.t(:posts_count, count: super)
    h.link_to(string, h.posts_path(filters: { realm_id: { min: _id, max: _id } }))
  end

  def post_categories_count
    string = h.t(:post_categories_count, count: super)
    h.link_to(string, h.post_categories_path(filters: { realm_id: { min: _id, max: _id } }))
  end
end
