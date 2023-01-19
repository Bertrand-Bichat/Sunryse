class ResetNinjaTimeJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.update(ninja_reset: false, ninja_time: 30)
  end
end
