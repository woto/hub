class FavoritePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(favorites: { user: user }).or(scope.where({ is_public: true }))
    end
  end

  def index?
    true
  end

  def create?
    true
  end

  def destroy?
    true if context.user_id == user.id
  end

  def update?
    true if context.user_id == user.id
  end

  def show?
    true if context.user_id == user.id
  end
end
