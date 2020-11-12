# frozen_string_literal: true

#
# # Where the I18n library should search for translation files
# I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
#
# # Permitted locales available for the application
# I18n.available_locales = [:en, :pt]
#
# # Set default locale to something other than :en
# I18n.default_locale = :ru

# Enable locale fallbacks for I18n (makes lookups for any locale fall back to
# the I18n.default_locale when a translation cannot be found).
Rails.application.configure do
  config.i18n.fallbacks = true
end
