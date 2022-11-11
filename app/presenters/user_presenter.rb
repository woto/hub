class UserPresenter
  def self.call(user)
    {}.tap do |hsh|
      if user
        hsh[:id] = user.id
        hsh[:email] = user.email
        hsh[:name] = user.profile.name if user.profile
        hsh[:avatar] = if user.avatar.present?
                         Rails.application.routes.url_helpers.polymorphic_path(
                           user.avatar.variant(resize_to_limit: [200, 200]),
                           only_path: true
                         )
                       else
                         ApplicationController.helpers.asset_path('avatar-placeholder.png')
                       end
      end
    end
  end
end
