# frozen_string_literal: true

if Rails.env.development?
  User.setup_index(Columns::UserForm)
  User.__elasticsearch__.create_index!(force: true)
  User.__elasticsearch__.refresh_index!

  Feed.setup_index(Columns::FeedForm)
  Feed.__elasticsearch__.create_index!
  Feed.__elasticsearch__.refresh_index!

  Post.setup_index(Columns::PostForm)
  Post.__elasticsearch__.create_index!
  Post.__elasticsearch__.refresh_index!

  PostCategory.setup_index(Columns::PostCategoryForm)
  PostCategory.__elasticsearch__.create_index!
  PostCategory.__elasticsearch__.refresh_index!

  Favorite.setup_index(Columns::FavoriteForm)
  Favorite.__elasticsearch__.create_index!
  Favorite.__elasticsearch__.refresh_index!

  Account.setup_index(Columns::AccountForm)
  Account.__elasticsearch__.create_index!
  Account.__elasticsearch__.refresh_index!

  Transaction.setup_index(Columns::TransactionForm)
  Transaction.__elasticsearch__.create_index!
  Transaction.__elasticsearch__.refresh_index!

  user = User.create!(email: 'admin@example.com',
                      password: 'password',
                      password_confirmation: 'password',
                      role: 'admin')

  yandex_money = AccountGroup.create!
  yandex_payed = Account.create!(
    subject: yandex_money, name: 'yandex_money_payed', code: 'payed', currency: :rub, kind: :passive
  )
  yandex_commission = Account.create!(
    subject: yandex_money, name: 'yandex_money_commission', code: 'payed', currency: :rub, kind: :passive
  )

  stakeholder = AccountGroup.create!
  stakeholder_payed = Account.create!(
    subject: stakeholder, name: 'stakeholder_payed', code: 'payed', currency: :rub, kind: :passive
  )

  hub = AccountGroup.create!
  hub_pending = Account.create!(
    subject: hub, name: 'hub_pending', code: 'pending', currency: :rub, kind: :active
  )
  hub_accrued = Account.create!(
    subject: hub, name: 'hub_accrued', code: 'accrued', currency: :rub, kind: :active
  )
  fund_payed = Account.create!(
    subject: hub, name: 'fund_payed', code: 'payed', currency: :rub, kind: :active
  )

  GlobalHelper.retryable do
    Accounting::Actions::StakeholderToFund.call(
      stakeholder_payed: stakeholder_payed, fund_payed: fund_payed,
      amount: 5_000_00
    )
  end

  pc = PostCategory.create(title: 'Тестовая категория')

  post = nil
  GlobalHelper.retryable do
    post = Post.create!(title: 'Заголовок', body: '<p>Статья</p>' * 10, user: user,
                        status: :draft, post_category: pc, language: 'Russian')
  end

  GlobalHelper.retryable do
    post.update!(status: :pending)
  end

  GlobalHelper.retryable do
    Current.set(user: user) do
      post.update!(status: :accrued)
    end
  end

  GlobalHelper.retryable do
    user_accrued = Account.find_by!(name: "##{user.id}_user_accrued")
    user_payed = Account.find_by!(name: "##{user.id}_user_payed")

    Accounting::Actions::AccruedToPaidWithYandex.call(
      user_accrued: user_accrued, hub_accrued: hub_accrued,

      fund_payed: fund_payed, yandex_payed: yandex_payed, yandex_commission: yandex_commission, user_payed: user_payed,

      amount: post.price
    )
  end

  advertiser = Advertiser.create!(name: 'Рекламодатель 1')
  advertiser_payed = Account.create!(
    subject: advertiser, name: "##{advertiser.id}_advertiser_payed", code: 'payed', currency: :rub, kind: :passive
  )

  GlobalHelper.retryable do
    Accounting::Actions::AdvertiserToBank.call(
      hub: fund_payed, advertiser: advertiser_payed,
      amount: 300_000
    )
  end

  advego_convertor = AccountGroup.create!
  advego_convertor_rub = Account.create!(
    subject: advego_convertor, name: 'advego_convertor_rub', code: 'payed', currency: :rub, kind: :passive
  )
  advego_convertor_usd = Account.create!(
    subject: advego_convertor, name: 'advego_convertor_usd', code: 'payed', currency: :usd, kind: :passive
  )

  advego = AccountGroup.create!
  advego_account_usd = Account.create!(
    subject: advego, name: 'advego_account_usd', code: 'payed', currency: :usd, kind: :active
  )
  advego_payed_usd = Account.create!(
    subject: advego, name: 'advego_payed_usd', code: 'payed', currency: :usd, kind: :passive
  )

  GlobalHelper.retryable do
    Accounting::Actions::FundToAdvegoAccountUsd.call(
      amount_in_rub: 800_00,
      amount_in_usd: 10_00,
      fund_payed: fund_payed,
      advego_convertor_rub: advego_convertor_rub,
      advego_convertor_usd: advego_convertor_usd,
      advego_account_usd: advego_account_usd
    )
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
