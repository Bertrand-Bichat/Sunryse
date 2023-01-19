class MessagesController < ApplicationController
  skip_before_action :test_user_authorization
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @message = Message.new
    authorize @message
    # add_breadcrumb 'Contact', new_message_path
  end

  def create
    @message = Message.new(message_params)
    authorize @message
    if @message.save
      send_mail
      redirect_to home_path, notice: 'Votre message a bien été envoyé à SUNRYSE. Nous vous répondrons dès que possible.'
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:first_name, :last_name, :email, :content, :phone_number)
  end

  def send_mail
    MessageMailer.with(message: @message).notification_message_send.deliver_later
  end
end
