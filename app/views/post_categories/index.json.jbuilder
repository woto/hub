json.array! @categories do |category|
  json.id category.id
  json.path category.path.join(' > ')
  json.title category.title
end
