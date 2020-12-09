class NewsRepository
  # include Elasticsearch::Persistence::Repository
  # include Elasticsearch::Persistence::Repository::DSL
  # client Elasticsearch::Client.new(Rails.application.config.elastic)
  # index_name "#{Rails.env}.news"
end
