# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  amount       :decimal(, )      default(0.0), not null
#  code         :integer          not null
#  comment      :string           not null
#  currency     :integer          not null
#  identifier   :uuid
#  kind         :integer          not null
#  subject_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  subject_id   :bigint           not null
#
# Indexes
#
#  account_set_uniqueness                         (identifier,kind,currency,subject_id,subject_type) UNIQUE
#  index_accounts_on_subject_type_and_subject_id  (subject_type,subject_id)
#
class Account < ApplicationRecord
  belongs_to :subject, polymorphic: true, optional: true

  include Elasticable
  # include Elasticsearch::Model::Callbacks
  index_name "#{Rails.env}.accounts"

  enum currency: Rails.configuration.global[:currencies]
  enum kind: { active: 1, passive: 0 }
  enum code: { pending: 0, accrued: 1, requested: 2, payed: 3 }

  before_validation on: :create do
    self.amount = 0
  end

  validates :amount, :code, :currency, :kind, :subject, presence: true

  # AccountGroup can have multiple accounts with same :currency and :code
  validates :identifier, uniqueness: true, if: -> { subject_type.in? %w[AccountGroup] }

  # User or Advertiser can have only one account with same :currency and :code
  validates :currency, uniqueness: { scope: %i[code subject_id subject_type] }, if: -> { subject_type.in? %w[User Advertiser] }

  # TODO: is there a way to engage parser gem and check statically
  # attempts to change unpermitted field values (all except `amount`)?

  validate if: ->(acc) { acc.persisted? } do
    unpermitted_changed_fields = changed_attributes.keys - ['amount']
    unpermitted_changed_fields.each do |field|
      errors.add(field, 'can not be changed')
    end
  end

  has_many :transactions_as_credit, class_name: "Transaction", foreign_key: :credit_id
  has_many :transactions_as_debit, class_name: "Transaction", foreign_key: :debit_id

  def as_indexed_json(_options = {})
    {
      id: id,
      amount: amount,
      code: code,
      currency: currency,
      identifier: identifier,
      comment: comment,
      kind: kind,
      subject_id: subject_id,
      subject_type: subject_type,
      subject_label: subject.to_label,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  class << self
    def for_user_pending_usd(user)
      user.accounts.find_or_create_by!(code: :pending, currency: :usd, kind: :passive) do |ag|
        ag.comment = 'for_user_pending_usd'
      end
    end

    def for_user_accrued_usd(user)
      user.accounts.find_or_create_by!(code: :accrued, currency: :usd, kind: :passive) do |ag|
        ag.comment = 'for_user_accrued_usd'
      end
    end

    def for_user_requested_usd(user)
      user.accounts.find_or_create_by!(code: :requested, currency: :usd, kind: :passive) do |ag|
        ag.comment = 'for_user_requested_usd'
      end
    end

    def for_user_payed_usd(user)
      user.accounts.find_or_create_by!(code: :payed, currency: :usd, kind: :passive) do |ag|
        ag.comment = 'for_user_payed_usd'
      end
    end

    def for_advertiser_payed_rub(advertiser)
      advertiser.accounts.find_or_create_by!(code: :payed, currency: :rub, kind: :passive) do |ag|
        ag.comment = 'for_advertiser_payed_rub'
      end
    end

    def hub_pending_usd
      uuid = '0eb402b6-5029-4f2d-ba13-9c28b78564a6'
      AccountGroup.hub.accounts.find_or_create_by!(identifier: uuid, code: :pending, currency: :usd, kind: :active) do |ag|
        ag.comment = 'hub_pending_usd'
      end
    end

    def hub_accrued_usd
      uuid = 'd7bbb84f-1b1d-497f-925f-81f8e46e3886'
      AccountGroup.hub.accounts.find_or_create_by!(identifier: uuid, code: :accrued, currency: :usd, kind: :active) do |ag|
        ag.comment = 'hub_accrued_usd'
      end
    end

    def hub_requested_usd
      uuid = '9ec481ff-e325-4ef4-89ed-fff1f11e3418'
      AccountGroup.hub.accounts.find_or_create_by!(identifier: uuid, code: :requested, currency: :usd, kind: :active) do |ag|
        ag.comment = 'hub_requested_usd'
      end
    end

    def hub_payed_usd
      uuid = '505c3a4e-d567-43d7-9be6-def39b09f7ca'
      AccountGroup.hub.accounts.find_or_create_by!(identifier: uuid, code: :payed, currency: :usd, kind: :active) do |ag|
        ag.comment = 'hub_payed_usd'
      end
    end

    def hub_pending_rub
      uuid = 'b3bb0560-8426-4e53-9a92-19ceedabd9ab'
      AccountGroup.hub.accounts.find_or_create_by!(identifier: uuid, code: :pending, currency: :rub, kind: :active) do |ag|
        ag.comment = 'hub_pending_rub'
      end
    end

    def hub_accrued_rub
      uuid = '56f682a5-6097-415d-81bd-86dd60ffce77'
      AccountGroup.hub.accounts.find_or_create_by!(identifier: uuid, code: :accrued, currency: :rub, kind: :active) do |ag|
        ag.comment = 'hub_accrued_rub'
      end
    end

    def hub_payed_rub
      uuid = '01e5c757-155a-4564-8440-8cf3b1ab805e'
      AccountGroup.hub.accounts.find_or_create_by!(identifier: uuid, code: :payed, currency: :rub, kind: :active) do |ag|
        ag.comment = 'hub_payed_rub'
      end
    end

    def yandex_payed
      uuid = 'd6241eb3-ba62-41ca-864b-d2c687d812b6'
      AccountGroup.yandex.accounts.find_or_create_by!(identifier: uuid, code: :payed, currency: :usd, kind: :passive) do |ag|
        ag.comment = 'yandex_payed'
      end
    end

    def yandex_commission
      uuid = '24641f0c-4636-46a9-ab81-cc1b3d46c373'
      AccountGroup.yandex.accounts.find_or_create_by!(identifier: uuid, code: :payed, currency: :usd, kind: :passive) do |ag|
        ag.comment = 'yandex_commission'
      end
    end

    def stakeholder_payed_rub
      uuid = '37067bc0-10a9-4bc3-9214-15799be826bf'
      AccountGroup.stakeholder.accounts.find_or_create_by!(identifier: uuid, code: :payed, currency: :rub, kind: :passive) do |ag|
        ag.comment = 'stakeholder_payed_rub'
      end
    end

    def advego_convertor_rub
      uuid = '477db258-745a-4006-ab81-77d2e8f87bb2'
      AccountGroup.advego.accounts.find_or_create_by!(identifier: uuid, code: :payed, currency: :rub, kind: :passive) do |ag|
        ag.comment = 'advego_convertor_rub'
      end
    end

    def advego_convertor_usd
      uuid = 'e9aa9b4d-0baf-4338-bc8d-006632994f88'
      AccountGroup.advego.accounts.find_or_create_by!(identifier: uuid, code: :payed, currency: :usd, kind: :passive) do |ag|
        ag.comment = 'advego_convertor_usd'
      end
    end

    def advego_account_usd
      uuid = 'e7252ac1-b8ae-4746-a354-e18c6f219d0e'
      AccountGroup.advego.accounts.find_or_create_by!(identifier: uuid, code: :payed, currency: :usd, kind: :active) do |ag|
        ag.comment = 'advego_account_usd'
      end
    end

    def hub_bank_rub
      uuid = '58cca0a6-1d7a-4c74-be22-d4d297f79292'
      AccountGroup.hub.accounts.find_or_create_by!(identifier: uuid, code: :payed, currency: :rub, kind: :active) do |ag|
        ag.comment = 'hub_bank_rub'
      end
    end

    # TODO
    # advego_payed_usd = Account.create!(
    #   subject: advego, name: 'account', code: 'payed', currency: :usd, kind: :passive
    # ) 63181466-316a-45d4-8513-feee972bca68

  end
end
