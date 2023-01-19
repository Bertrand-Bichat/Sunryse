class ContactRequestPolicy < ApplicationPolicy
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
      (record.sender == user) && authorization
    end
  end

  def mark_as_accepted?
    if user_loggedin?
      ((record.receiver == user) && (record.accepted == false)) && authorization
    end
  end

  def hide_contact_request?
    if user_loggedin?
      ((record.sender == user) || (record.receiver == user)) && authorization
    end
  end
end
