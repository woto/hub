json.array! @tags.aggregations.grouped_documents.grouped_tags.buckets do |tag|
  json.title tag['key']
end
