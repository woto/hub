# == Schema Information
#
# Table name: realms
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  locale     :string           not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Realm < ApplicationRecord
  validates :locale, :title, presence: true

  def to_label
    "#{locale}: #{title}"
  end

  class << self
    def default_realm
      @default_realm ||= Realm.find_or_create_by!(title: 'По-умолчанию', locale: 'ru')
    end
  end
end
