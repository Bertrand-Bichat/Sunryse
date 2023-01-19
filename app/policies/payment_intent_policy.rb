class PaymentIntentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def filtered_index?
    if user_loggedin?
      user.admin?
    end
  end

  def refund?
    if user_loggedin?
      user.admin? && (record.amount_cents > 0) && ![ApplicationController.helpers.succeeded, ApplicationController.helpers.pending].include?(record.refund_status)
    end
  end

  def check_refund_status?
    if user_loggedin?
      user.admin? && (record.refund_id != nil) && ![nil, ApplicationController.helpers.succeeded].include?(record.refund_status)
    end
  end
end
