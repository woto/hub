# frozen_string_literal: true

json.array! @favorites do |favorite|
  json.id favorite.id
  json.name favorite.name
  json.count favorite.count
  json.is_checked favorite.is_checked == 1 ? true : false
end
