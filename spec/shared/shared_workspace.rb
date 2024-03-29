# frozen_string_literal: true

require 'rails_helper'

shared_examples 'shared workspace unauthenticated' do
  describe 'save workspace' do
    before do
      find("[data-action='table-workspace-form#toggleForm']").click
    end

    it 'proposes to login' do
      within('#workspace-form') do
        click_button 'Сохранить'
      end
      expect(page).to have_current_path(new_user_session_path, url: false)
      expect(page).to have_text('Вам необходимо войти в систему или зарегистрироваться.')
    end
  end
end

shared_examples 'shared workspace authenticated' do
  context 'when user has default workspace' do
    it 'loads automatically when user visits `plural`' do
      login_as(user, scope: :user)
      create(:workspace,
             is_default: true,
             user: user,
             controller: "tables/#{plural}",
             path: "/ru/#{plural}?cols=0&order=asc&page=1&per=10&sort=id")
      visit "/ru/#{plural}"
      expect(page).to have_current_path("/ru/#{plural}?cols=0&order=asc&page=1&per=10&sort=id")
    end
  end

  context 'when user clicks on saved workspace' do
    it 'loads workspace params' do
      login_as(user, scope: :user)
      workspace = create(:workspace,
                         is_default: false,
                         user: user,
                         controller: "tables/#{plural}",
                         path: "/ru/#{plural}?cols=0&order=asc&page=1&per=10&sort=id")
      visit "/ru/#{plural}"
      click_on workspace.name
      expect(page).to have_current_path("/ru/#{plural}?cols=0&order=asc&page=1&per=10&sort=id")
    end
  end

  describe 'workspace form visibility' do
    before do
      login_as(user, scope: :user)
      visit "/ru/#{plural}"
    end

    it 'shows and hides form' do
      # initially form is not shown
      expect(page).to have_css('.d-none[data-table-workspace-form-target="form"]', visible: false)

      # clicking on the button shows form
      find("[data-action='table-workspace-form#toggleForm']").click
      expect(page).to have_css('.d-block[data-table-workspace-form-target="form"]', visible: true)

      # clicking on the button again hides form
      find("[data-action='table-workspace-form#toggleForm']").click
      expect(page).to have_css('.d-none[data-table-workspace-form-target="form"]', visible: false)
    end
  end

  describe 'workspaces list' do
    describe 'index' do
      let!(:workspace1) { create(:workspace, controller: "tables/#{plural}", user: user) }
      let!(:workspace2) { create(:workspace, controller: "tables/#{plural}") }

      before do
        login_as(user, scope: :user)
        visit "/ru/#{plural}"
      end

      it "includes only the user's workspaces" do
        expect(page).to have_css("#left_workspace_#{workspace1.id}")
        expect(page).to have_no_css("#left_workspace_#{workspace2.id}")
        within("#left_workspace_#{workspace1.id}") do
          expect(page).to have_link(workspace1.name, href: Regexp.new(workspace1.path))
        end
      end
    end

    describe 'destroy' do
      context 'when clicks `x` at workspace link' do
        let!(:workspace) { create(:workspace, controller: "tables/#{plural}", user: user) }

        before do
          login_as(user, scope: :user)
          visit "/ru/#{plural}"
        end

        it 'removes workspace' do
          expect do
            accept_confirm do
              click_link("delete-workspace-#{workspace.id}")
            end
            expect(page).to have_none_of_selectors(:link, "delete-workspace-#{workspace.id}")
          end.to change(user.workspaces, :count).from(1).to(0)

          expect(page).to have_text('Рабочая область была успешно удалена')
        end
      end

      it "doesn't remove other users workspaces" do
        skip 'this test can not be written in systems tests'
      end
    end
  end

  describe 'form interactions' do
    before do
      login_as(user, scope: :user)
      visit "/ru/#{plural}"
      find("[data-action='table-workspace-form#toggleForm']").click
    end

    context 'when name filled in submitted form' do
      let(:name) { Faker::Lorem.word }

      it 'saves workspace and shows link to workspace' do
        expect do
          within('#workspace-form') do
            fill_in 'Введите имя', with: name
            click_button 'Сохранить'
          end
          expect(page).to have_text(name)
        end.to change(user.workspaces, :count)
      end
    end

    context 'when there was an error in previous save step' do
      let(:name) { Faker::Lorem.word }

      it 'still saves form on next attempt' do
        expect do
          # failed to save
          within('#workspace-form') do
            click_button 'Сохранить'
            expect(page).to have_text('Название не может быть пустым')
          end

          # succeeded to save
          within('#workspace-form') do
            fill_in 'Введите имя', with: name
            click_button 'Сохранить'
          end

          within('.left_workspace') do
            expect(page).to have_text(name)
          end
        end.to change(user.workspaces, :count)
      end
    end

    context 'when name does not filled in submitted form' do
      it 'does not save form and show errors' do
        expect do
          within('#workspace-form') do
            click_button 'Сохранить'
            expect(page).to have_text('Название не может быть пустым')
          end
        end.not_to change(user.workspaces, :count)
      end
    end
  end
end
