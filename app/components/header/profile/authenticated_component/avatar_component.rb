# frozen_string_literal: true

class Header::Profile::AuthenticatedComponent::AvatarComponent < ViewComponent::Base
  def before_render
    @avatar_path = if helpers.current_user.avatar.attached?
                     helpers.url_for(@avatar.variant(resize_to_limit: [200, 200]))
                   else
                     asset_path('avatar-placeholder.png')
                   end
  end

  def initialize(avatar:)
    @avatar = avatar
  end
end
