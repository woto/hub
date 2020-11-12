# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  amount       :integer          default(0), not null
#  code         :integer          not null
#  currency     :integer          not null
#  kind         :integer          not null
#  name         :string           not null
#  subject_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  subject_id   :bigint           not null
#
# Indexes
#
#  index_accounts_on_subject_type_and_subject_id  (subject_type,subject_id)
#
class Account < ApplicationRecord
  belongs_to :subject, polymorphic: true, optional: true

  include Elasticable
  # include Elasticsearch::Model::Callbacks
  index_name "#{Rails.env}.accounts"

  enum currency: { rub: 643, eur: 978, usd: 840 }
  enum kind: { active: 1, passive: 0 }
  enum code: { pending: 0, accrued: 1, payed: 2 }

  before_validation on: :create do
    self.amount = 0
  end

  validates :name, :kind, :amount, :currency, :subject, presence: true
  validates :name, uniqueness: true

  # TODO: is there a way to engage parser gem and check statically
  # attempts to change unpermitted field values (all except `amount`)?

  validate if: ->(acc) { acc.persisted? } do
    unpermitted_changed_fields = changed_attributes.keys - ['amount']
    unpermitted_changed_fields.each do |field|
      errors.add(field, 'is immutable')
    end
  end

  def as_indexed_json(_options = {})
    {
        id: id,
        amount: amount,
        currency: currency,
        code: code,
        kind: kind,
        name: name,
        subject: "##{subject.id}_#{subject.class.table_name}",
        created_at: created_at,
        updated_at: updated_at
    }
  end

  def to_label
    "#{name} (#{code}/#{kind})"
  end
end
