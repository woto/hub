RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by ENV.fetch('CAPYBARA_DRIVER', :selenium).to_sym,
              using: ENV.fetch('CAPYBARA_BROWSER', :headless_chrome).to_sym,
              screen_size: [1400, 1400]
  end
end
