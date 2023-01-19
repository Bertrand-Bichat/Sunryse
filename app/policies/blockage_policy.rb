class BlockagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def filtered_index?
    authorization
  end

  def create?
    authorization
  end

  def destroy?
    if user_loggedin?
      (record.initiator == user) && authorization
    end
  end
end
