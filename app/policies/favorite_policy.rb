class FavoritePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    authorization
  end

  def destroy?
    if user_loggedin?
      (record.user == user) && authorization
    end
  end
end
