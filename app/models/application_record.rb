# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  after_commit do
    self.class.reflect_on_all_associations(:belongs_to).each do |association|
      if association.options[:counter_cache]
        record = public_send(association.name)
        ReindexRecordJob.perform_later(record)
      end
    end
  end
end
