# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_context 'shared mention fill helpers' do
  def fill_url(url:, with_image:)
    mocked_response = if with_image
                        {
                          status: 200,
                          body: {
                            image: 'data:image/jpeg;base64,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',
                            publisher: nil,
                            title: 'Title'
                          }.to_json
                        }
                      else
                        {
                          status: 500,
                          body: {
                            error: 'Some error'
                          }.to_json
                        }
                      end

    stub_request(:get, "http://scrapper:4000/screenshot?url=#{url}")
      .to_return(mocked_response)

    fill_in('URL', with: url)
  end

  def fill_image(file_name:)
    page.attach_file(file_fixture(file_name)) do
      # NOTE: don't remember how to write it prettier, somehow like click_on('entity_image')
      find('label[for="mention_image"]').click
    end
  end

  def assign_entity(entity:)
    click_on('Добавить объект')
    within('.modal') do
      fill_in('Поиск объекта', with: entity.title)
      sleep(0.5)
      click_on("assign-entity-#{entity.id}")
    end
  end

  def create_entity(title:)
    expect do
      click_on('Добавить объект')
      fill_in('Поиск объекта', with: 'New entity')
      click_on('Создать новый')
      fill_in('Название', with: title)
      click_on('Сохранить')
      expect(page).not_to have_css('.modal')

      last_entity = Entity.last

      expect(page).to have_css("#card_entity_#{last_entity.id}")
      expect(page).to have_css("#edit_entity_#{last_entity.id}")
      expect(page).to have_css("#remove_entity_#{last_entity.id}")
    end.to change(Entity, :count).by(1)
  end

  def fill_topics(topics:)
    find('#heading-mention-topics-item').click
    topics.each do |topic|
      within '.mention_topics' do
        find('.selectize-input').click
        find('input').native.send_key(topic)
        find('input').native.send_key(:enter)
      end
    end
  end

  def fill_sentiments(sentiments:)
    find('#heading-mention-sentiments-item').click
    sentiments.each do |sentiment|
      check("mention_sentiments_#{sentiment}", allow_label_click: true)
    end
  end

  def fill_kinds(kinds:)
    find('#heading-mention-kinds-item').click
    kinds.each do |kind|
      check("mention_kinds_#{kind}", allow_label_click: true)
    end
  end

  def fill_published_at; end
end
