# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    return true if user && user.admin?

    false
  end

  def show?
    return true if user && user.admin?

    false
  end

  def create?
    return true if user && user.admin?

    false
  end

  def new?
    return true if user && user.admin?

    create?
  end

  def update?
    return true if user && user.admin?

    false
  end

  def edit?
    return true if user && user.admin?

    update?
  end

  def destroy?
    return true if user && user.admin?

    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.none
    end
  end
end
