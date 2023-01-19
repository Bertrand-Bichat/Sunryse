class MessageMailer < ApplicationMailer
  # envoi d'un mail a l'admin quand quelqu'un utilise le formulaire d el apage 'contact'
  def notification_message_send
    @message = params[:message]
    # @admin = User.find_by(admin: true)
    @customer_name = "#{@message.first_name.capitalize} #{@message.last_name.capitalize}"

    mail(
      # to: @admin.email,
      to: ENV['SUNRYSE_EMAIL'],
      subject: "Message envoyé par #{@customer_name} depuis la page 'contact' de votre site SUNRYSE"
    )
  end
end
