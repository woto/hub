# == Schema Information
#
# Table name: workspaces
#
#  id         :bigint           not null, primary key
#  controller :string
#  is_default :boolean          default(FALSE), not null
#  name       :string
#  path       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_workspaces_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

describe Workspace, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
