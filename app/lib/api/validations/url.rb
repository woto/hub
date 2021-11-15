# frozen_string_literal: true

class Url < Grape::Validations::Base
  def validate_param!(attr_name, params)
    url = params[attr_name]
    URI.parse(url).tap { |uri| raise 'wrong url' unless uri.host && %w[http https].include?(uri.scheme) }
  rescue StandardError
    raise Grape::Exceptions::Validation, params: [@scope.full_name(attr_name)],
                                         message: 'must be url, e.g. https://ya.ru'
  end
end
