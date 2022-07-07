# frozen_string_literal: true

module Elasticsearch
  class IndexJob < ApplicationJob
    queue_as :low

    def perform(record)
      record.__elasticsearch__.send_document_to_elasticsearch
    end
  end
end
