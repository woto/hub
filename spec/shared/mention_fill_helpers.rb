# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_context 'shared mention fill helpers' do
  def fill_url(url:, with_image:)
    mocked_response = if with_image
                        {
                          status: 200,
                          body: {
                            image: Base64Helpers.image,
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

  def fill_kinds(kinds:)
    find('#heading-mention-kinds-item').click
    kinds.each do |kind|
      check("mention_kinds_#{kind}", allow_label_click: true)
    end
  end

  def fill_published_at; end
end
