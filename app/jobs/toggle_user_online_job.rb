class ToggleUserOnlineJob < ApplicationJob
  queue_as :critical

  def perform(user, boolean)
    if user.online != boolean
      user.update(online: boolean)
    end
  end
end
