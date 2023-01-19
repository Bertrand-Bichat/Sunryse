class CreateChatroomJob < ApplicationJob
  queue_as :default

  def perform(user1, user2)
    Chatroom.create(speaker1: user1, speaker2: user2)
  end
end
