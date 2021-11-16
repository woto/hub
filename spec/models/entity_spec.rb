# frozen_string_literal: true

# == Schema Information
#
# Table name: entities
#
#  id             :bigint           not null, primary key
#  aliases        :jsonb
#  mentions_count :integer          default(0), not null
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Entity, type: :model do
  it_behaves_like 'elasticable'
  it_behaves_like 'logidzable'

  describe 'associations' do
    it { is_expected.to have_many(:entities_mentions) }
    it { is_expected.to have_many(:mentions).through(:entities_mentions) }
    it { is_expected.to have_one_attached(:picture) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe '#as_indexed_json', responsible: :user do
    subject { entity.as_indexed_json }

    around do |example|
      freeze_time do
        example.run
      end
    end

    let(:entity) do
      create(:entity,
             mentions: [create(:mention)],
             picture: Rack::Test::UploadedFile.new(file_fixture('avatar.png')))
    end

    it 'returns correct result' do
      expect(subject).to match(
        id: entity.id,
        aliases: entity.aliases,
        title: entity.title,
        picture: be_a(String),
        mentions_count: entity.mentions_count,
        created_at: Time.current,
        updated_at: Time.current
      )
    end
  end

  describe '#to_label' do
    subject { create(:entity, title: 'entity') }

    specify do
      expect(subject.to_label).to eq('entity')
    end
  end
end
