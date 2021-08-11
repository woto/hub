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
require 'rails_helper'

RSpec.describe Widget, type: :model do
  it 'has valid factory' do
    create(:simple_widget)
  end

  it 'creates valid widget' do
    user = create(:user)
    create(:simple_widget, user: user)
  end

  it 'includes `GlobalID::Identification`' do
    expect(described_class).to include(GlobalID::Identification)
  end

  it 'includes `ActionText::Attachable`' do
    expect(described_class).to include(ActionText::Attachable)
  end

  it 'overrides `to_trix_content_attachment_partial_path`' do
    widget = create(:simple_widget)
    expect(widget.to_trix_content_attachment_partial_path).to eq('widgets/preview')
  end
end
