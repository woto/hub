module FavorableConcern
  extend ActiveSupport::Concern

  included do
    def is_favorite
      context[:favorites].find(self)
    end
  end
end
