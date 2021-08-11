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
require 'rails_helper'

RSpec.describe Widgets::Simples::Picture, type: :model do
  it { is_expected.to have_one_attached(:picture) }
end
