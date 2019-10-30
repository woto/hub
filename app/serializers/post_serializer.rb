class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :url
  has_one :user
end
