class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def filtered_index?
    user_loggedin?
  end

  def current_order?
    user_loggedin?
  end

  def basket?
    user_loggedin?
  end

  # only for man
  def choose_prices?
    if user_loggedin?
      user.gender == ApplicationController.helpers.male
    end
  end

  def create?
    user_loggedin?
  end

  def pay_order?
    if user_loggedin?
      (record.user == user) && (record.state == ApplicationController.helpers.order_state_wait)
    end
  end

  def destroy?
    if user_loggedin?
      (record.user == user) && (record.state == ApplicationController.helpers.order_state_wait)
    end
  end

  def unsubcribed?
    if user_loggedin?
      (user.admin? || (record.user == user)) && (record.state == ApplicationController.helpers.order_state_payed) && (record.order_type == ApplicationController.helpers.order_type_subscription) && (record.active == true) && (record.unsubscribed == false) && ((record.duration == ApplicationController.helpers.three_month && record.invoices_number >= 3) || (record.duration == ApplicationController.helpers.six_month && record.invoices_number >= 6))
    end
  end
end
