# frozen_string_literal: true

class Mentions::KindIconComponent < ViewComponent::Base
  def initialize(kind:)
    @kind = kind
  end

  def render?
    @kind.present?
  end

  def kind_to_icon
    lookup_table = {
      'text' => 'fa-fw fa-lg fas fa-file-alt',
      'image' => 'fa-fw fa-lg fas fa-image',
      'audio' => 'fa-fw fa-lg fas fa-volume-down',
      'video' => 'fa-fw fa-lg fas fa-video'
    }
    lookup_table.fetch(@kind)
  end
end
