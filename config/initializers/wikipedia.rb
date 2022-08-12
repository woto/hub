Wikipedia.configure do
  domain 'ru.wikipedia.org'
end

# NOTE: In this case library returns nil images, due to internal Wikipedia... call,
# which is configured on en.wikipedia.org
#
# config_ru = Wikipedia::Configuration.new(
#   domain: 'ru.wikipedia.org',
# )
# client_ru = Wikipedia::Client.new(config_ru)
