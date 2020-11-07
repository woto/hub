# frozen_string_literal: true

class PostStatusesPolicy < ApplicationPolicy
  def to_pending?
    return true if record.status_before_last_save.in?([nil, 'draft', 'pending', 'rejected'])
  end
  alias to_draft? to_pending?

  def to_accrued?
    true if user.role.in?(%w[admin manager])
  end

  def to_rejected?
    true if user.role.in?(%w[admin manager])
  end

  def to_canceled?
    true if user.role.in?(%w[admin manager])
  end
end
