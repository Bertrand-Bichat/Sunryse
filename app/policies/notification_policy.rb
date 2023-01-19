class NotificationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def filtered_index?
    authorization
  end

  def ninja_mode?
    authorization
  end

  def hide_notification?
    if user_loggedin?
      ((record.sender == user) || (record.receiver == user)) && authorization
    end
  end
end
