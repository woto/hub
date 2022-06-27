# frozen_string_literal: true

require 'rails_helper'

describe MentionsController, type: :system, responsible: :admin do
  include_context 'shared mention fill helpers'

  before do
    login_as(Current.responsible, scope: :user)
    visit new_mention_path(locale: :ru)
  end

  topics_error_text = 'Topics не может быть пустым и Topics недостаточной длины (не может быть меньше 1 символа)'

  xcontext 'when topics is not filled' do
    it 'shows topics error text' do
      click_on('Сохранить')
      expect(page).to have_text(topics_error_text)
    end
  end

  context 'when topics is filled' do
    it 'does not show topics error text' do
      fill_topics(topics: ['topic 1', 'topic 2'])
      expect(page).not_to have_text(topics_error_text)
    end
  end

  context 'when one topic already exists and another not yet exists' do
    let!(:topic) { create(:topic) }
    let!(:entity) { create(:entity) }

    it 'creates new topic and reuses other' do
      fill_url(url: 'https://example.com', with_image: true)
      fill_topics(topics: ['new', topic.title])
      assign_entity(entity: entity)

      expect do
        expect do
          expect do
            click_on('Сохранить')
            expect(page).to have_text('Упоминание было успешно создано')
          end.to change(Topic, :count).by(1)
        end.to change(MentionsTopic, :count).by(2)
      end.to change(Mention, :count).by(1)
    end
  end
end
