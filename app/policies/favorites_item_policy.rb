class FavoritesItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      s = scope.joins(:favorite)
      s = s.where(favorites: { user: }) if user
      s
    end
  end
end
