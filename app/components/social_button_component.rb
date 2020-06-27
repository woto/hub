class SocialButtonComponent < ViewComponent::Base
  def initialize(link_class:, type:, title:, path:)
    @link_class = link_class
    @type = type
    @title = title
    @path = path
  end
end
