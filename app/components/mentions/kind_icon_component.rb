# frozen_string_literal: true

class Mentions::KindIconComponent < ViewComponent::Base
  def initialize(kind:, hint: false)
    @kind = kind
    @hint = hint
  end

  def render?
    @kind.present?
  end

  def kind_to_icon
    lookup_table = {
      'text' => 'fas fa-fw fa-file-alt',
      'image' => 'fas fa-fw fa-image',
      'audio' => 'fas fa-fw fa-volume-down',
      'video' => 'fas fa-fw fa-video'
    }
    lookup_table.fetch(@kind)
  end
end
