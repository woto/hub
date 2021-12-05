# frozen_string_literal: true

class Mentions::EntityPolicy < ApplicationPolicy
  def assign?
    true
  end

  def search?
    true
  end

  def card?
    true
  end

  def update?
    MentionPolicy.new(user, context).update?
  end

  def create?
    MentionPolicy.new(user, context).create?
  end
end
