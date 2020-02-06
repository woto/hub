Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do

    namespace :v1 do

      namespace :staff do

        namespace :cropper do

          namespace 'elastic' do
            get 'crop'
          end

          namespace 'postgres' do
            get 'crop'
          end

        end

        namespace 'seeder' do

          namespace 'elastic' do
            get 'pagination'
          end

          namespace 'postgres' do
            get 'create_user'
            get 'create_another_user'
            get 'create_unconfirmed_user'
            get 'create_social_user'
            get 'send_reset_password_instructions'
            get 'send_confirmation_instructions'
          end

          namespace 'redis' do
            get 'get_ready_for_proxy'
          end

        end
      end
    end
  end
end
