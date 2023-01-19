class PublicationPolicy < ApplicationPolicy
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

  def update?
    if user_loggedin?
      (record.user == user) && authorization
    end
  end

  def destroy?
    if user_loggedin?
      (record.user == user) && authorization
    end
  end
end
