#

module Helpers
  def json_response_body
    JSON.parse(response.body)
  end

  def elastic_client
    @elastic_client ||= Elasticsearch::Client.new Rails.application.config.elastic
  end
end
