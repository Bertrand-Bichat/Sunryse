class CreateNotificationJob < ApplicationJob
  queue_as :default

  def perform(sender, receiver, content)
    Notification.create(sender: sender, receiver: receiver, content: content)
  end
end
