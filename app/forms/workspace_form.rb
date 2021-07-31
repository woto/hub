# frozen_string_literal: true

class WorkspaceForm
  include ActiveModel::Serialization
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend ActiveModel::Naming

  attr_accessor :name, :is_default, :state, :model

  validates :name, presence: true
end
