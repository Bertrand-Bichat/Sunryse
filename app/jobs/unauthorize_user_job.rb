class UnauthorizeUserJob < ApplicationJob
  queue_as :critical

  def perform(user, order)
    order.update(cancel_date: Date.today, active: false)
    user.update(authorized: false)
  end
end
