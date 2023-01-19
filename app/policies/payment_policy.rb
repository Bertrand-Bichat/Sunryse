class PaymentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    if user_loggedin?
      record.user == user
    end
  end
end
