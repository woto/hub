RSpec.configure do |config|
  config.around do |example|
    user = create(:user, role: example.metadata[:responsible])
    Current.set(responsible: user) do
      example.run
    end
  end
end
