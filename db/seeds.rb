# frozen_string_literal: true


if Rails.env.development?
  user = User.create!(email: 'admin@example.com',
                      password: 'password',
                      password_confirmation: 'password',
                      role: 'admin')

  Post.create!(title: 'Заголовок', body:'<p>Статья</p>', user: user)

  advertiser = Advertiser.create!(name: 'Рекламодатель 1')

  feed1 = advertiser.feeds.create!(
    attempt_uuid: SecureRandom.uuid,
    url: 'http://example.com',
    name: 'Прайс 1',
    operation: 'seeds',
    xml_file_path: 'spec/fixtures/files/feeds/yml-custom.xml'
  )
  Feeds::Parse.call(feed: feed1)

  feed2 = advertiser.feeds.create!(
    attempt_uuid: SecureRandom.uuid,
    url: 'http://example.com',
    name: 'Прайс 2',
    operation: 'seeds',
    xml_file_path: 'spec/fixtures/files/feeds/yml-simplified.xml'
  )
  Feeds::Parse.call(feed: feed2)

  advertiser = Advertiser.create!(name: 'Рекламодатель 2')

  feed3 = advertiser.feeds.create!(
    attempt_uuid: SecureRandom.uuid,
    url: 'http://example.com',
    name: 'Прайс 3',
    operation: 'seeds',
    xml_file_path: 'spec/fixtures/files/feeds/776-petshop+678-taganrog.xml'
  )
  Feeds::Parse.call(feed: feed3)
end
