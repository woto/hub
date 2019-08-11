# frozen_string_literal: true

# Used in User model
module Authenticationable
  extend ActiveSupport::Concern
  include RolesConstants

  included do
    enum role: [ROOT, ADMIN, USER]
    after_initialize :set_default_role, if: :new_record?

    def set_default_role
      self.role ||= :user
    end
  end
end
