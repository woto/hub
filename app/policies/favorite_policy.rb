class FavoritePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(favorites: { user: user })
    end
  end

  def index?
    true
  end
end
