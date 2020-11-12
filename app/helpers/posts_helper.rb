# frozen_string_literal: true

module PostsHelper
  def _title(value)
    truncate(value, length: 80)
  end
end
