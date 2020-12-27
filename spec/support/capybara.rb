# frozen_string_literal: true

Capybara.test_id = 'data-test-id'
# Capybara.server = :puma, { Silent: true }
# ActiveSupport.on_load(:action_dispatch_system_test_case) do
#   ActionDispatch::SystemTesting::Server.silence_puma = true
# end

[
  { name: :mobile, resolution: [375, 812] },
  { name: :desktop, resolution: [1280, 1024] }
].each do |item|
  name = item[:name]
  resolution = item[:resolution]
  # Capybara.server = :puma, { Silent: true }
  Capybara.register_driver name do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_option('prefs', 'intl.accept_languages' => 'ru')
    options.add_argument("--lang=ru")
    if ActiveModel::Type::Boolean.new.cast(ENV.fetch('CAPYBARA_HEADLESS'))
      options.headless!
    end

    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      # desired_capabilities: capabilities,
      # http_client: client,
      options: options
    ).tap do |driver|
      driver.browser.manage.window.size = Selenium::WebDriver::Dimension.new(*resolution)
    end
  end
end

# RSpec.configure do |config|
#   config.before(:each, type: :system, browser: :rack) do
#     driven_by :rack_test
#   end
# end

RSpec.configure do |config|
  config.before(:each, type: :system) do |opts|
    if opts.metadata[:browser].to_s == 'mobile'
      driven_by :mobile
    else
      driven_by :desktop
    end
  end
end
