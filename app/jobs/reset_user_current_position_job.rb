class ResetUserCurrentPositionJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.update(current_latitude: nil, current_longitude: nil)
  end
end
