# frozen_string_literal: true

Capybara.test_id = 'data-test-id'
# Capybara.default_max_wait_time = 5

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
    # TODO: hm...
    # capabilities = Selenium::WebDriver::Remote::Capabilities.chrome( "goog:loggingPrefs": { browser: 'ALL' } )

    options = Selenium::WebDriver::Chrome::Options.new
    # NOTE: Maybe github actions doesn't have russian locale in Chrome.
    # So we can't set it in CI. But locally it works.
    # More robust is to pass manually locale in params and get
    # predictable results instead of relying on Chrome configuration.
    # options.add_option('prefs', 'intl.accept_languages' => 'ru')
    # options.add_argument("--lang=ru")

    # WARN Selenium [DEPRECATION] [:headless] `Options#headless!` is deprecated. Use `Options#add_argument('--headless=new')` instead.
    options.add_argument('--headless=new') if ActiveModel::Type::Boolean.new.cast(ENV.fetch('CAPYBARA_HEADLESS'))

    # # NOTE: trying to fix github actions
    # options.add_argument('--disable-gpu')

    Capybara::Selenium::Driver.new(
      app,
      # timeout: 60,
      browser: :chrome,
      # TODO: hm...
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

RSpec.configure do |config|
  def switch_domain(domain)
    original_app_host = Capybara.app_host
    Capybara.app_host = "http://#{domain}"
    yield
  ensure
    Capybara.app_host = original_app_host
  end
end

# Capybara::Chromedriver::Logger::TestHooks.for_rspec!
