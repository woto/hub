json.array! @categories do |category|
  json.id category.id
  # # json.path category.path.join(' > ')
  # json.title category.title_i18n[params[:post_language]]
  json.path category.path.join(' > ')
  json.title category.title
end
