RSpec.configure do |config|
  config.before(:suite) do
    Kernel.srand config.seed
    Faker::Config.random = Random.new(config.seed)
  end
end
