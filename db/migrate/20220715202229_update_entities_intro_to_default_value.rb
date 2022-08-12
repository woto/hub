class UpdateEntitiesIntroToDefaultValue < ActiveRecord::Migration[6.1]
  def change
    # TODO: remove me later
    Entity.where(intro: nil).find_each do |entity|
      entity.update(intro: 'описание отсутствует')
    end
  end
end
