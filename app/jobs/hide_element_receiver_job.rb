class HideElementReceiverJob < ApplicationJob
  queue_as :critical

  def perform(element)
    element.update(visible_receiver: false)
  end
end
