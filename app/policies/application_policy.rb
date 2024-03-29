# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :context

  def initialize(user, context)
    @user = user
    @context = context
  end

  def index?
    return true if user && user.staff?

    false
  end

  def show?
    return true if user && user.staff?

    false
  end

  def create?
    return true if user && user.staff?

    false
  end

  def new?
    create?
  end

  def update?
    return true if user && user.staff?

    false
  end

  def edit?
    update?
  end

  def destroy?
    return true if user && user.staff?

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
