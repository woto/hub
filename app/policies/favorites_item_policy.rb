class FavoritesItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:favorite).where(favorites: { user: user })
    end
  end
end
