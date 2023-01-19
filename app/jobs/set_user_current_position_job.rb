class SetUserCurrentPositionJob < ApplicationJob
  queue_as :default

  def perform(user, position)
    user.update(current_latitude: position[0], current_longitude: position[1]) if position && position != []
  end
end
