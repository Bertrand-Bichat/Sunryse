class ChatroomsController < ApplicationController

  def index
    blockages = find_blockages
    @chatrooms = (policy_scope(Chatroom).where(speaker1: current_user).includes(:speaker1, :speaker2, :posts).uniq.delete_if { |chatroom| blockages.include?(chatroom.speaker2) || chatroom.speaker2.banned? } + policy_scope(Chatroom).where(speaker2: current_user).includes(:speaker1, :speaker2, :posts).uniq.delete_if { |chatroom| blockages.include?(chatroom.speaker1) || chatroom.speaker1.banned? }).sort_by { |chatroom| chatroom.id }
  end

  def show
    @chatroom = authorize policy_scope(Chatroom).includes(posts: :user).find(params[:id])
    @post = Post.new
    blockages = find_blockages
    @chatrooms = (policy_scope(Chatroom).where(speaker1: current_user).includes(:speaker1, :speaker2, :posts).uniq.delete_if { |chatroom| blockages.include?(chatroom.speaker2) || chatroom.speaker2.banned? } + policy_scope(Chatroom).where(speaker2: current_user).includes(:speaker1, :speaker2, :posts).uniq.delete_if { |chatroom| blockages.include?(chatroom.speaker1) || chatroom.speaker1.banned? }).sort_by { |chatroom| chatroom.id }

    if current_user == @chatroom.speaker1
      @other_speaker = @chatroom.speaker2
    else
      @other_speaker = @chatroom.speaker1
    end

    # create token for current_user
    naked_token = TwilioVideo.access_token(current_user.id)
    # create a room name
    @room_name = @chatroom.class.name.downcase + "_" + @chatroom.id.to_s
    # grant user for @room_name
    @token = TwilioVideo.grant_room_access(naked_token, @room_name)
    # for credits form
    @order = Order.new
  end

  def use_credit
    @chatroom = authorize policy_scope(Chatroom).find(params[:id])

    if (current_user.credit_activated == false) && (current_user.camera_credits_balance > 0)
      current_user.update(credit_activated: true)
      ReduceUserCreditJob.perform_later(current_user)
      DesactivateCreditModeJob.set(wait: 30.minutes).perform_later(current_user)
    end
  end
end
