# frozen_string_literal: true

if Rails.env.development?

  GlobalHelper.create_elastic_indexes

  Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
    load seed
  end

  website = Realm.create!(title: 'Яндекс Маркет', locale: 'ru', kind: 'website')

  user = User.create!(email: 'user@example.com',
                      password: 'password',
                      password_confirmation: 'password',
                      role: 'user')

  admin = User.create!(email: 'admin@example.com',
                       password: 'password',
                       password_confirmation: 'password',
                       role: 'admin')

  group = TransactionGroup.create!(
    kind: 'stakeholder_to_hub'
  )

  Current.set(responsible: admin) do
    Accounting::Actions::StakeholderToHub.call(
      stakeholder_payed: Account.stakeholder_payed_rub,
      hub_payed: Account.hub_payed_rub,
      amount: 50_000.to_d,
      group: group
    )
  end

  post = nil

  Current.set(responsible: user) do
    post = Post.create!(realm: website, title: 'Заголовок', intro: Faker::Lorem.paragraphs(number: 10).join,
                        body: Faker::Lorem.paragraph(sentence_count: 1, random_sentences_to_add: 20), user: user,
                        status: :draft, post_category: PostCategory.joins(:realm).merge(Realm.website).order('RANDOM()').first,
                        currency: :usd, published_at: Time.current, tags: ['тест', 'тестовые тег'])
    post.update!(status: :pending)
  end

  Current.set(responsible: admin) do
    post.update!(status: :accrued)
  end

  # TODO
  #   group = TransactionGroup.create!(
  #     kind: 'accrued_to_paid_with_yandex'
  #   )
  #   Accounting::Actions::AccruedToPaidWithYandex.call(
  #     user_accrued: Account.for_user_accrued_usd(user),
  #     hub_accrued: Account.hub_accrued_usd,
  #
  #     hub_payed: Account.hub_payed_usd,
  #     yandex_payed: Account.yandex_payed_usd,
  #     yandex_commission: Account.yandex_commission_usd,
  #     user_payed: Account.for_user_payed_usd(user),
  #
  #     amount: post.price,
  #     group: group
  #   )

  advertiser = Advertiser.create!(name: 'Рекламодатель 1')

  group = TransactionGroup.create!(
    kind: 'advertiser_to_hub_payed_rub'
  )
  Current.set(responsible: admin) do
    Accounting::Actions::AdvertiserToHubPayedRub.call(
      hub_bank_rub: Account.hub_bank_rub,
      hub_payed_rub: Account.hub_payed_rub,
      advertiser_rub: Account.for_advertiser_payed_rub(advertiser),
      amount: 30_000.to_d,
      group: group
    )
  end

  group = TransactionGroup.create!(
    kind: 'hub_rub_to_advego_account_usd'
  )
  Current.set(responsible: admin) do
    Accounting::Actions::HubToAdvegoAccountUsd.call(
      amount_in_rub: 5_000.to_d,
      amount_in_usd: 60.to_d,
      hub_payed: Account.hub_payed_rub,
      advego_convertor_rub: Account.advego_convertor_rub,
      advego_convertor_usd: Account.advego_convertor_usd,
      advego_account_usd: Account.advego_account_usd,
      group: group
    )
  end

  Current.set(responsible: user) do
    user.checks.create!(amount: 1, currency: :rub)
  end

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
