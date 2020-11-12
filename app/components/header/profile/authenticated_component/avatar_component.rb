# frozen_string_literal: true

class Header::Profile::AuthenticatedComponent::AvatarComponent < ViewComponent::Base
  def before_render
    @avatar_path = if helpers.current_user.avatar.attached?
                     helpers.url_for(@avatar.variant(resize_to_limit: [200, 200]))
                   else
                     'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'
                   end
  end

  def initialize(avatar:)
    @avatar = avatar
  end
end
