class ReduceNinjaTimeJob < ApplicationJob
  queue_as :default

  def perform(user, time)
    new_time = user.ninja_time - time
    user.update(ninja_time: new_time)
  end
end
