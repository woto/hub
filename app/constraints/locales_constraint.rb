# frozen_string_literal: true

class LocalesConstraint
  def matches?(request)
    case request.params['locale']
    when nil
      true
    when *I18n.available_locales.map(&:to_s)
      true
    end
  end
end
