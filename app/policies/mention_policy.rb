# frozen_string_literal: true

class MentionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def permitted_attributes
    attributes = [
      :published_at, :url, :image, :title, :html,
      { kinds: [], tags: [], advertiser_ext_ids: [], topics_attributes: [],
        related_entities: %i[id is_main] }
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
