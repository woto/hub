class FavoritePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(favorites: { user: user })
    end
  end

  def index?
    true
  end

  def create?
    true
  end

  def destroy?
    true if record.user_id == user.id
  end

  def update?
    true if record.user_id == user.id
  end

  def show?
    true if record.user_id == user.id
  end
end
