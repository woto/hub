# == Schema Information
#
# Table name: widgets
#
#  id              :bigint           not null, primary key
#  widgetable_type :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#  widgetable_id   :bigint           not null
#
# Indexes
#
#  index_widgets_on_user_id     (user_id)
#  index_widgets_on_widgetable  (widgetable_type,widgetable_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Widget < ApplicationRecord
  belongs_to :user
  delegated_type :widgetable, types: %w[Widgets::Simple]

  include GlobalID::Identification
  include ActionText::Attachable

  def to_trix_content_attachment_partial_path
    'widgets/preview'
  end
end
