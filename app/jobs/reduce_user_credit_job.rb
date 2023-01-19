class ReduceUserCreditJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.update(camera_credits_balance: user.camera_credits_balance - 1)
  end
end
