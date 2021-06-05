RSpec.configure do |config|
  config.around do |example|
    role = example.metadata[:responsible]
    next example.run if role.blank?

    user = create(:user, role: role)
    Current.set(responsible: user) do
      example.run
    end
  end
end
