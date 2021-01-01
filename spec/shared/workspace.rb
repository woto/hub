# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'shared_workspace' do

  context 'when user is not authorized' do
    describe 'save workspace' do
      before do
        visit "/ru/#{plural}"
      end

      it 'proposes to login' do
        within('#workspace-form') do
          click_button 'Сохранить'
          expect(page).to have_current_path(new_user_session_path, url: false)
        end
      end
    end
  end

  context 'when user is authorized' do

    describe 'workspace form visibility' do
      before do
        login_as(user, scope: :user)
        visit "/ru/#{plural}"
      end

      context 'when page loads' do
        it 'does not show workspace form' do
          expect(page).to have_css('.d-none[data-target="table-workspace-form.form"]', visible: false)
        end
      end

      context 'when clicks on "workspaces"' do
        it 'shows workspace form' do
          click_on 'show-workspace-form'
          expect(page).to have_css('.d-block[data-target="table-workspace-form.form"]', visible: true)
        end
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
          expect(page).not_to have_css("#left_workspace_#{workspace2.id}")
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
        click_on 'show-workspace-form'
      end

      context 'when name filled in submitted form' do
        let('name') { Faker::Lorem.word }

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
        let('name') { Faker::Lorem.word }

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

            expect(page).to have_text(name)

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
end

# expect(page).to(
#   have_current_path(
#     url_for(controller: plural, action: :index, locale: 'ru',
#             cols: cols, order: 'desc', per: '20', sort: 'id', only_path: true),
#     url: false
#   )
# )
