json.array! @navbar_favorite_items do |item|
  json.title item.name
  json.href url_for(controller: "/#{item.kind}", favorite_id: item.id)
end
