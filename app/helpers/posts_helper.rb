# frozen_string_literal: true

module PostsHelper
  def _title(value)
    raise 'PostsHelper::_title'
    truncate(value, length: 80)
  end
end
