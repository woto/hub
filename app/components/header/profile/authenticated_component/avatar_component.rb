class Header::Profile::AuthenticatedComponent::AvatarComponent < ViewComponent::Base

  def before_render
    if helpers.current_user.avatar.attached?
      @avatar_path = helpers.url_for(@avatar)
    else
      @avatar_path = 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'
    end
  end

  def initialize(avatar:)
    @avatar = avatar
  end
end
