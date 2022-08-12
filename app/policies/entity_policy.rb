# frozen_string_literal: true

class EntityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def permitted_attributes
    attributes = [
      :title, :picture, :image, :intro, :body,
      { child_ids: [], parent_ids: [], topics_attributes: [], lookups_attributes: %i[id title _destroy] }
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
    true

    # return true if super
    #
    # true if user && context.user == user
  end

  def destroy?
    return true if super

    true if user && context.user == user
  end

  def popover?
    true
  end
end
