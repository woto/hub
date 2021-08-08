class SetProfileMessengersAsAnArrayByDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :profiles, :messengers, from: nil, to: []
  end
end
