# frozen_string_literal: true

require 'rails_helper'

describe MentionsController, type: :system, responsible: :admin do
  include_context 'shared mention fill helpers'
  check_items_error = 'список содержит дубликаты'

  context 'when mention is new' do
    before do
      login_as(Current.responsible, scope: :user)
      visit new_mention_path(locale: :ru)
    end

    context 'when assigning two same entities' do
      let!(:entity) { create(:entity, title: 'some entity') }

      it 'shows check_items error' do
        fill_url(url: 'https://example.com', with_image: true)
        fill_topics(topics: ['new'])
        fill_sentiment(sentiment: 'positive')
        fill_kinds(kinds: ['text'])

        assign_entity(title: entity.title)
        assign_entity(title: entity.title)

        expect do
          expect do
            expect do
              click_on('Сохранить')
              expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
              expect(page).to have_text(check_items_error)
            end.not_to change(Mention, :count)
          end.not_to change(Entity, :count)
        end.not_to change(EntitiesMention, :count)
      end
    end

    context 'when form data is valid (with assigning persisted entity)' do
      let!(:entity) { create(:entity, title: 'some entity') }

      it 'creates new mention' do
        fill_url(url: 'https://example.com', with_image: true)
        fill_topics(topics: ['new'])
        fill_sentiment(sentiment: 'positive')
        fill_kinds(kinds: ['text'])

        assign_entity(title: entity.title)

        expect do
          expect do
            expect do
              click_on('Сохранить')
              expect(page).to have_text('Упоминание было успешно создано')
            end.to change(Mention, :count).by(1)
          end.not_to change(Entity, :count)
        end.to change(EntitiesMention, :count).by(1)
      end
    end

    context 'when form data is valid (with creating new entity)' do
      it 'saves mention with new entity' do
        fill_url(url: 'https://example.com', with_image: true)
        fill_topics(topics: ['new'])
        fill_sentiment(sentiment: 'positive')
        fill_kinds(kinds: ['text'])

        create_entity(title: 'new entity')

        expect do
          expect do
            expect do
              click_on('Сохранить')
              expect(page).to have_text('Упоминание было успешно создано')
            end.to change(Mention, :count).by(1)
          end.not_to change(Entity, :count)
        end.to change(EntitiesMention, :count).by(1)
      end
    end

    context 'when form data is invalid (with assigning persisted entity)' do
      let!(:entity) { create(:entity, title: 'some entity') }

      it 'does not save mention' do
        fill_url(url: '', with_image: false)

        assign_entity(title: entity.title)

        expect do
          expect do
            expect do
              click_on('Сохранить')
              expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
            end.not_to change(Mention, :count)
          end.not_to change(Entity, :count)
        end.not_to change(EntitiesMention, :count)
      end
    end

    context 'when form data is invalid (with creating new entity)' do
      it 'does not save mention' do
        fill_url(url: '', with_image: false)

        create_entity(title: 'new entity')

        expect do
          expect do
            expect do
              click_on('Сохранить')
              expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
            end.not_to change(Mention, :count)
          end.not_to change(Entity, :count)
        end.not_to change(EntitiesMention, :count)
      end
    end
  end

  context 'when mention is persisted' do
    before do
      login_as(Current.responsible, scope: :user)
      visit edit_mention_path(mention, locale: :ru)
    end

    let!(:mention) { create(:mention, image_data: image_data) }
    let!(:entity) { create(:entity, title: 'some entity') }
    let(:image_data) do
      ImageUploader.upload(File.open('spec/fixtures/files/jessa_rhodes.jpg', 'rb'), :store).as_json
    end

    context 'when assigns new entity and tries to save mention with invalid url (with assigning entity)' do
      it 'does add new entity' do
        assign_entity(title: entity.title)
        fill_url(url: '', with_image: true)

        expect do
          expect do
            expect do
              click_on('Сохранить')
              expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
            end.not_to change(Mention, :count)
          end.not_to change(EntitiesMention, :count)
        end.not_to change(Entity, :count)
      end
    end

    context 'when creates new entity and tries to save mention with invalid url (with creating entity)' do
      it 'does not add entity' do
        create_entity(title: 'new entity')
        fill_url(url: '', with_image: true)

        expect do
          expect do
            expect do
              click_on('Сохранить')
              expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
            end.not_to change(Mention, :count)
          end.not_to change(EntitiesMention, :count)
        end.not_to change(Entity, :count)
      end
    end

    context 'when assigns same entity again' do
      it 'does not store and shows error' do
        assign_entity(title: mention.entities.first.title)

        expect do
          expect do
            expect do
              click_on('Сохранить')
              expect(page).to have_text('Невозможно сохранить. Пожалуйста заполните поля')
              expect(page).to have_text(check_items_error)
            end.not_to change(Mention, :count)
          end.not_to change(EntitiesMention, :count)
        end.not_to change(Entity, :count)
      end
    end

    context 'when assigns new entity' do
      let!(:entity) { create(:entity, title: 'new entity') }

      it 'saves mention with appended entity' do
        assign_entity(title: entity.title)

        expect do
          expect do
            expect do
              expect do
                click_on('Сохранить')
                expect(page).to have_text('Упоминание было успешно изменено')
              end.to(change { mention.entities.count })
            end.to change(EntitiesMention, :count).by(1)
          end.not_to change(Entity, :count)
        end.not_to change(Mention, :count)
      end
    end

    context 'when creates new entity' do
      it 'saves mention with appended entity' do
        create_entity(title: 'new entity')

        expect do
          expect do
            expect do
              expect do
                click_on('Сохранить')
                expect(page).to have_text('Упоминание было успешно изменено')
              end.to(change { mention.entities.count })
            end.to change(EntitiesMention, :count).by(1)
          end.not_to change(Entity, :count)
        end.not_to change(Mention, :count)
      end
    end
  end
end
