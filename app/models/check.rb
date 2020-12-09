# == Schema Information
#
# Table name: checks
#
#  id         :bigint           not null, primary key
#  amount     :decimal(, )      not null
#  currency   :integer          not null
#  is_payed   :boolean          not null
#  payed_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_checks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Check < ApplicationRecord
  belongs_to :user

  include CheckStatuses
  include Elasticable
  # include Elasticsearch::Model::Callbacks
  index_name "#{Rails.env}.checks"

  validates :amount, :currency, presence: true
  validates :amount, numericality: { greater_than: 0 }
  enum currency: Rails.configuration.global[:currencies]

  validate do
    if is_payed? && !payed_at?
      errors.add(:payed_at, :not_empty)
    end

    if payed_at? && !is_payed?
      errors.add(:is_payed, :not_empty)
    end
  end

  before_create do
    self.is_payed = false
    self.payed_at = nil
    self.currency = :usd
  end

  after_save do
    case is_payed
    when false
      to_requested
    when true
      to_payed
    end
  end

  def as_indexed_json(_options = {})
    {
        id: id,
        amount: amount,
        currency: currency,
        is_payed: is_payed,
        payed_at: payed_at,
        user_id: user_id,
        created_at: created_at,
        updated_at: updated_at
    }
  end
end
