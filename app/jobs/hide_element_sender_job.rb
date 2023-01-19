class HideElementSenderJob < ApplicationJob
  queue_as :critical

  def perform(element)
    element.update(visible_sender: false)
  end
end
