class UserPresenter
  def self.call(user)
    {}.tap do |hsh|
      if user
        hsh[:id] = user.id
        hsh[:email] = user.email
        hsh[:unconfirmed_email] = user.unconfirmed_email
        hsh[:role] = user.role
        hsh[:name] = user.profile&.name
        hsh[:bio] = user.profile&.bio
        hsh[:languages] = user.profile&.languages.then { |languages| languages.compact_blank if languages }
        hsh[:time_zone] = user.profile&.time_zone
        hsh[:languages] = user.profile&.languages
        hsh[:api_key] = user.api_key
        hsh[:messengers] = user.profile&.messengers
        hsh[:avatar] = GlobalHelper.image_hash([user.avatar_relation].compact, %w[100]).first&.then do |image|
          {
            id: image['id'],
            image_url: ImageUploader::IMAGE_TYPES.include?(image['mime_type']) ? image['images']['100'] : nil
          }
        end
        hsh[:created_at] = user.created_at
      end
    end
  end
end
