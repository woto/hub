module SearchBarable
  extend ActiveSupport::Concern

  included do
    before_action :set_preserved_search_params
  end
end
