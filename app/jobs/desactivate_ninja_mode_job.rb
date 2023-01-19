class DesactivateNinjaModeJob < ApplicationJob
  queue_as :critical

  def perform(user)
    user.update(ninja_activated: false)
  end
end
