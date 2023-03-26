# frozen_string_literal: true

module Elasticsearch
  class IndexJob < ApplicationJob
    queue_as :low

    def perform(record)
      record.__elasticsearch__.index_document
      record.class.__elasticsearch__.refresh_index!
    end
  end
end
