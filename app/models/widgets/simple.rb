# frozen_string_literal: true

# == Schema Information
#
# Table name: widgets_simples
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Widgets
  class Simple < ApplicationRecord
    include Widgetable

    has_many :pictures, class_name: 'Widgets::Simples::Picture',
                        foreign_key: :widgets_simple_id,
                        inverse_of: :widgets_simple

    accepts_nested_attributes_for :pictures, allow_destroy: true

    validates :body, :title, :url, presence: true
    validates :pictures, length: { minimum: 1 }
    validate :url_valid?

    private

    def url_valid?
      return if errors.details[:url].any?

      result = GlobalHelper.elastic_client.search(Widgets::SearchOfferByUrlQuery.call(url: url).object)
      errors.add(:url, :invalid) if result['hits']['hits'].empty?
    end
  end
end
