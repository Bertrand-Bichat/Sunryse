class DesactivateCreditModeJob < ApplicationJob
  queue_as :critical

  def perform(user)
    user.update(credit_activated: false)
  end
end
