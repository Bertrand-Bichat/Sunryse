class PostsController < ApplicationController

  def create
    @chatroom = policy_scope(Chatroom).find(params[:chatroom_id])
    @post = Post.new(post_params)
    @post.chatroom = @chatroom
    @post.user = current_user
    authorize @post

    if current_user == @chatroom.speaker1
      @receiver = @chatroom.speaker2
    elsif current_user == @chatroom.speaker2
      @receiver = @chatroom.speaker1
    end

    if @post.save
      CreateNotificationJob.perform_later(current_user, @receiver, helpers.notifications_post)
      if @receiver.notification_post_received?
        NotificationMailer.with(receiver: @receiver, sender: current_user).post_received.deliver_later
      end

      ChatroomChannel.broadcast_to(@chatroom, render_to_string(partial: "post", locals: { post: @post }))
      redirect_to chatroom_path(@chatroom, anchor: "post-#{@post.id}")
    else
      render "chatrooms/show"
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
