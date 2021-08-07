module Filters
  class BaseForm
    include ActiveModel::Serialization
    include ActiveModel::Model
    include ActiveModel::Attributes
    # extend ActiveModel::Naming

    def model_name
      ActiveModel::Name.new(self, nil, 'filter_form')
    end

    attr_accessor :column, :state, :model
  end
end
