# frozen_string_literal: true

class MentionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'responsible is not set' unless user

      if user.staff?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def permitted_attributes
    attributes = [
      :kind, :published_at, :sentiment, :status, :url, :screenshot, :currency, :amount,
      { entity_ids: [], tags: [], advertiser_ext_ids: [] }
    ]
    attributes.append(:user_id) if user.staff?
    attributes
  end

  def update?
    return true if super

    true if context.user == user && (context.draft_mention? || context.pending_mention? || context.rejected_mention?)
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

    true if context.user == user && (context.draft_mention? || context.pending_mention? || context.rejected_mention?)
  end
end
