class ChatroomPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    if user_loggedin?
      ((record.speaker1 == user) || (record.speaker2 == user)) && authorization
    end
  end

  def use_credit?
    if user_loggedin?
      ((record.speaker1 == user || record.speaker2 == user) && ((record.speaker1.camera_credits_balance > 0) || (record.speaker1.credit_activated == true)) && ((record.speaker2.camera_credits_balance > 0) || (record.speaker2.credit_activated == true))) && authorization
    end
  end
end
