# frozen_string_literal: true

module Users
  class ProfileInteractor
    include ApplicationInteractor

    contract do
      params do
        required(:current_user).value(type?: User)
        required(:params).maybe do
          hash do
            required(:name).maybe(:string)
            required(:bio).maybe(:string)
            required(:time_zone).maybe(:string) do
              included_in?(ActiveSupport::TimeZone.all.map(&:name))
            end
            # optional(:languages).array(:string).each(
            #   included_in?: 'ru', 'en']
            # )
            required(:languages).maybe do
              each(
                included_in?: Rails.application.config.global[:locales].pluck(:locale)
              )
            end
            required(:messengers).maybe do
              array(:hash) do
                required(:type).value(:str?).value(
                  included_in?: Rails.application.config.global[:messengers].pluck(:long)
                )
                required(:value).value(:str?).value(:filled?)
              end
            end
            required(:avatar)
          end
        end
      end
    end

    def call
      ActiveRecord::Base.transaction do
        profile = (context.current_user.profile || context.current_user.build_profile).lock!
        profile.update!(
          {
            name: context.params[:name],
            bio: context.params[:bio],
            time_zone: context.params[:time_zone],
            languages: context.params[:languages],
            messengers: context.params[:messengers]
          }
        )

        if context.params.dig(:avatar, 'data')
          context.current_user.avatar_relation&.destroy
          avatar = Image.create!(image: context.params.dig(:avatar, 'data'), user: context.current_user)
          ImagesRelation.create!(image: avatar, relation: context.current_user, user: context.current_user)
        end

        context.current_user.touch
      end
    end
  end
end
