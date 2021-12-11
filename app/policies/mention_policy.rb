# frozen_string_literal: true

class MentionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def permitted_attributes
    attributes = [
      :published_at, :sentiment, :url, :image, :title,
      { kinds: [], entity_form_ids: [], tags: [], advertiser_ext_ids: [], topics_attributes: [] }
    ]
    attributes.append(:user_id) if user.staff?
    attributes
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true if user
  end

  def update?
    return true if super

    true if user && context.user == user
  end

  def destroy?
    return true if super

    true if user && context.user == user
  end
end
