# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'responsible is not set' unless user

      if user.role.in?(%w[admin manager])
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def permitted_attributes
    attributes = [
      :title, :status, :intro, :body, :language, :post_category_id, :published_at, :realm_id, :currency,
      { tags: [], extra_options: {} }
    ]
    attributes << :user_id if user.role.in?(%w[admin manager])
    attributes
  end

  def update?
    return true if super

    true if context.user == user && (context.draft_post? || context.pending_post? || context.rejected_post?)
  end

  def create?
    true
  end

  def index?
    true
  end

  def show?
    return true if super

    true if context.user == user
  end

  def destroy?
    return true if super

    true if context.user == user && (context.draft_post? || context.pending_post? || context.rejected_post?)
  end
end
