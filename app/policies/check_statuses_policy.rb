# frozen_string_literal: true

class CheckStatusesPolicy < ApplicationPolicy
  def to_requested?
    return true if record.is_payed_before_last_save.in?([nil])
  end

  def to_payed?
    true if user.role.in?(%w[admin manager])
  end
end
