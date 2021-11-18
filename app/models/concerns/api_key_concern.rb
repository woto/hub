module APIKeyConcern
  extend ActiveSupport::Concern

  included do
    before_save :assign_api_key

    def assign_api_key
      self.api_key ||= generate_api_key
    end

    def assign_api_key!
      self.api_key = generate_api_key
    end

    private

    def generate_api_key
      loop do
        token = Devise.friendly_token
        break token unless User.find_by(api_key: token)
      end
    end
  end
end
