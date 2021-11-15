class ApiKeyStrategy < Warden::Strategies::Base
  def valid?
    api_key.present?
  end

  def authenticate!
    user = User.find_by(api_key: api_key)

    if user
      success!(user)
    else
      fail!('Invalid API key. Use API-KEY header or api_key query string parameter.')
    end
  end

  def store?
    false
  end

  private

  def api_key
    params['api_key'] || env['HTTP_API_KEY']
  end
end
