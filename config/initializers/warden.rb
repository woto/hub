# frozen_string_literal: true

Rails.application.config.after_initialize do
  Warden::Strategies.add(:api_key, APIKeyStrategy)
end
