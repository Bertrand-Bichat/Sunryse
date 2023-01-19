class MarkAsReadJob < ApplicationJob
  queue_as :default

  def perform(instance)
    instance.update(readed: true)
  end
end
