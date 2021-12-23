# frozen_string_literal: true

require 'rails_helper'

describe MentionsController, type: :system, responsible: :admin do
  include_context 'shared mention fill helpers'

  context 'when mention is new' do
    before do
      login_as(Current.responsible, scope: :user)
      visit new_mention_path(locale: :ru)
    end

    context 'when assigning two same entities' do
      let!(:entity) { create(:entity, title: 'some entity') }

      it 'saves form with uniq entities' do
        fill_url(url: 'https://example.com', with_image: true)
        fill_topics(topics: ['new'])
        fill_sentiments(sentiments: ['positive'])
        fill_kinds(kinds: ['text'])

        assign_entity(entity: entity)
        assign_entity(entity: entity)

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

    context 'when form data is valid (with assigning persisted entity)' do
      let!(:entity) { create(:entity, title: 'some entity') }

      it 'creates new mention' do
        fill_url(url: 'https://example.com', with_image: true)
        fill_topics(topics: ['new'])
        fill_sentiments(sentiments: ['positive'])
        fill_kinds(kinds: ['text'])

        assign_entity(entity: entity)

        expect do
          expect do
            expect do
              click_on('Сохранить')
              expect(page).to have_text('Упоминание было успешно создано', wait: 5)
            end.to change(Mention, :count).by(1)
          end.not_to change(Entity, :count)
        end.to change(EntitiesMention, :count).by(1)
      end
    end

    context 'when form data is valid (with creating new entity)' do
      it 'saves mention with new entity' do
        fill_url(url: 'https://example.com', with_image: true)
        fill_topics(topics: ['new'])
        fill_sentiments(sentiments: ['positive'])
        fill_kinds(kinds: ['text'])

        create_entity(title: 'new entity')

        expect do
          expect do
            expect do
              click_on('Сохранить')
              expect(page).to have_text('Упоминание было успешно создано', wait: 5)
            end.to change(Mention, :count).by(1)
          end.not_to change(Entity, :count)
        end.to change(EntitiesMention, :count).by(1)
      end
    end

    context 'when form data is invalid (with assigning persisted entity)' do
      let!(:entity) { create(:entity, title: 'some entity') }

      it 'does not save mention' do
        fill_url(url: '', with_image: false)

        assign_entity(entity: entity)

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
        assign_entity(entity: entity)
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
      it 'saves form with uniq entities' do
        assign_entity(entity: mention.entities.first)

        expect do
          expect do
            expect do
              click_on('Сохранить')
              expect(page).to have_text('Упоминание было успешно изменено', wait: 5)
            end.not_to change(Mention, :count)
          end.not_to change(EntitiesMention, :count)
        end.not_to change(Entity, :count)
      end
    end

    context 'when assigns new entity' do
      let!(:entity) { create(:entity, title: 'new entity') }

      it 'saves mention with appended entity' do
        assign_entity(entity: entity)

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

    context 'when mention already has entity1 and entity2 and assigns entity1 and entity3' do
      let!(:mention) { create(:mention, entities: [entity1, entity2], image_data: image_data) }
      let!(:entity1) { create(:entity, title: 'entity 1') }
      let!(:entity2) { create(:entity, title: 'entity 2') }
      let!(:entity3) { create(:entity, title: 'entity 3') }

      it 'saves form with uniq entities' do
        assign_entity(entity: entity1)
        assign_entity(entity: entity3)

        expect do
          expect do
            expect do
              click_on('Сохранить')
              expect(page).to have_text('Упоминание было успешно изменено', wait: 5)
            end.not_to change(Mention, :count)
          end.to change(EntitiesMention, :count).by(1)
        end.not_to change(Entity, :count)

        expect(mention.reload.entities).to contain_exactly(entity1, entity2, entity3)
      end
    end
  end
end
