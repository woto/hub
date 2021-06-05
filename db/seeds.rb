# frozen_string_literal: true

if Rails.env.development?

  GlobalHelper.create_elastic_indexes

  admin = User.create!(
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password',
    role: 'admin'
  )

  user = User.create!(
    email: 'user@example.com',
    password: 'password',
    password_confirmation: 'password',
    role: 'user'
  )

  Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
    load seed
  end

  3.times do |i|
    user = User.create!(
      email: "user_#{i + 1}@example.com",
      password: 'password',
      password_confirmation: 'password',
      role: 'user'
    )

    10.times do |i|
      post = nil
      Current.set(responsible: user) do
        created_at = Faker::Date.between(from: 2.years.ago, to: Time.current)
        post = FactoryBot.create(:post, realm_kind: :post, user: user, created_at: created_at)
      end

      next unless i < 8

      Current.set(responsible: admin) do
        post.update!(status: :approved_post)
      end

      next unless i < 6

      Current.set(responsible: admin) do
        post.update!(status: :accrued_post)
      end

      next unless i < 4

      check = nil
      Current.set(responsible: user) do
        check = user.checks.create!(amount: post.amount * rand(0.9..1), currency: post.currency, status: :pending_check)
      end

      next unless i < 3

      Current.set(responsible: admin) do
        check.update!(status: :approved_check)
      end

      next unless i < 2

      Current.set(responsible: admin) do
        check.update!(status: :payed_check)
      end
    end
  end

  advertiser = Advertiser.create!(name: 'Рекламодатель 1')

  feed1 = advertiser.feeds.create!(
    attempt_uuid: SecureRandom.uuid,
    url: 'http://example.com',
    name: 'Прайс 1',
    operation: 'manual',
    xml_file_path: 'spec/fixtures/files/feeds/yml-custom.xml'
  )
  Feeds::Parse.call(feed: feed1)

  feed2 = advertiser.feeds.create!(
    attempt_uuid: SecureRandom.uuid,
    url: 'http://example.com',
    name: 'Прайс 2',
    operation: 'manual',
    xml_file_path: 'spec/fixtures/files/feeds/yml-simplified.xml'
  )
  Feeds::Parse.call(feed: feed2)

  advertiser = Advertiser.create!(name: 'Рекламодатель 2')

  feed3 = advertiser.feeds.create!(
    attempt_uuid: SecureRandom.uuid,
    url: 'http://example.com',
    name: 'Прайс 3',
    operation: 'manual',
    xml_file_path: 'spec/fixtures/files/feeds/776-petshop+678-taganrog.xml'
  )
  Feeds::Parse.call(feed: feed3)
  Elastic::RefreshOffersIndex.call
end
