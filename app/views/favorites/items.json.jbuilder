json.partial! "kaminari/pagination", items: @favorites_items

json.items do
  json.array! @favorites_items do |favorites_item|
    json.favorite do
      json.name favorites_item.favorite.name
      json.id favorites_item.favorite.id
    end
    json.item do
      json.id favorites_item.id
      json.ext_id favorites_item.ext_id
      json.data favorites_item.data
    end
  end
end
