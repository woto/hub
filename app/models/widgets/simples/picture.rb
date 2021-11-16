# frozen_string_literal: true

# == Schema Information
#
# Table name: widgets_simples_pictures
#
#  id                :bigint           not null, primary key
#  order             :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  widgets_simple_id :bigint           not null
#
# Indexes
#
#  index_widgets_simples_pictures_on_widgets_simple_id  (widgets_simple_id)
#
# Foreign Keys
#
#  fk_rails_...  (widgets_simple_id => widgets_simples.id)
#
module Widgets
  module Simples
    class Picture < ApplicationRecord
      belongs_to :widgets_simple, class_name: 'Widgets::Simple'

      delegate_missing_to :picture
      has_one_attached :picture
    end
  end
end
