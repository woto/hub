# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'shared_workspace' do
  before do
    login_as(user, scope: :user)
  end

  context 'when workspace already exists' do
    let(:workspace) { create(:workspace, controller: plural, user: user) }

    before do
      workspace
    end

    it 'shows link to it', browser: :desktop do
      visit "/ru/#{plural}"
      within("#left_workspace_#{workspace.id}") do
        expect(page).to have_link(workspace.name, href: Regexp.new(workspace.path))
      end
    end

    context 'when clicks `x` at workspace link' do
      it 'removes workspace', browser: :desktop do
        visit "/ru/#{plural}"
        expect do
          accept_confirm do
            click_link("delete-workspace-#{workspace.id}")
          end
          expect(page).to have_no_css("#delete-workspace-#{workspace.id}")
        end.to change(user.workspaces, :count).by(-1)
      end
    end
  end

  context 'when url contains `dwf=1`' do
    it 'shows workspace form', browser: :desktop do
      visit "/ru/#{plural}?cols=0&per=20&dwf=1"
      expect(page).to have_css('[data-test-id="workspace-form"]')
    end
  end

  context 'when url does not contain `dwf=1`' do
    it 'does not show workspace form', browser: :desktop do
      visit "/ru/#{plural}?cols=0&per=20"
      expect(page).to have_no_css('[data-test-id="workspace-form"]')
    end
  end

  context 'when name filled into submitted form' do
    let('name') { Faker::Lorem.word }

    it 'saves workspace', browser: :desktop do
      visit "/ru/#{plural}?cols=0&per=20&dwf=1"
      within('[data-test-id="workspace-form"]') do
        fill_in 'Введите имя', with: name
        expect do
          click_button 'Сохранить'
          expect(page).to(
            have_current_path(
              url_for(controller: plural, action: :index, locale: 'ru',
                      cols: 0, per: 20, only_path: true),
              url: false
            )
          )
        end.to change(user.workspaces, :count)
      end
    end

    context 'when name does not filled in submitted form' do
      let('name') { Faker::Lorem.word }

      it 'does not save if name is absent', browser: :desktop do
        visit "/ru/#{plural}?cols=0&dwf=1&per=20"
        within('[data-test-id="workspace-form"]') do
          click_button 'Сохранить'
          expect(page).to(
            have_current_path(
              url_for(controller: plural, action: :index, locale: 'ru', cols: 0,
                      per: 20, dwf: 1, only_path: true),
              url: false
            )
          )
        end
      end
    end
  end
end
