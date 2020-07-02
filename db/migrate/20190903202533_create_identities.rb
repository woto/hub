# frozen_string_literal: true

# https://github.com/omniauth/omniauth/wiki/Managing-Multiple-Providers
class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.string :uid, null: false
      t.string :provider, null: false
      t.references :user, null: false, foreign_key: true
      t.jsonb :auth, null: false

      t.timestamps
    end
  end
end
