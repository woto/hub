json.pagination do
  json.count items.count
  json.limit_value items.limit_value
  json.total_pages items.total_pages
  json.current_page items.current_page
  json.next_page items.next_page
  json.prev_page items.prev_page
  json.first_page items.first_page?
  json.last_page items.last_page?
  json.out_of_range items.out_of_range?
end
