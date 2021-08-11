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
FactoryBot.define do
  factory :widgets_simples_picture, class: 'Widgets::Simples::Picture' do
    # widgets_simple
    order { Faker::Number.number(digits: 3) }
    # see comments in spec/requests/settings/avatars_controller_spec.rb
    picture do
      [
        Rack::Test::UploadedFile.new('spec/fixtures/files/adriana_chechik.jpg'),
        Rack::Test::UploadedFile.new('spec/fixtures/files/jessa_rhodes.jpg')
      ].sample
    end
  end
end
