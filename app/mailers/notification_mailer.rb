class NotificationMailer < ApplicationMailer

  def contact_request_received
    @receiver = params[:receiver]
    @sender = params[:sender]
    # @admin = User.find_by(admin: true)

    mail(
      # to: @admin.email,
      to: @receiver.email,
      subject: "Vous avez reçu une demande de contact sur SUNRYSE"
    )
  end

  def contact_request_accepted
    @receiver = params[:receiver]
    @sender = params[:sender]
    # @admin = User.find_by(admin: true)

    mail(
      # to: @admin.email,
      to: @sender.email,
      subject: "Votre demande de contact sur SUNRYSE a été acceptée"
    )
  end

  def contact_request_readed
    @receiver = params[:receiver]
    @sender = params[:sender]
    # @admin = User.find_by(admin: true)

    mail(
      # to: @admin.email,
      to: @sender.email,
      subject: "Votre demande de contact sur SUNRYSE a été vu"
    )
  end

  def favorite_added
    @receiver = params[:receiver]
    @sender = params[:sender]
    # @admin = User.find_by(admin: true)

    mail(
      # to: @admin.email,
      to: @receiver.email,
      subject: "Votre profil sur SUNRYSE a été mis en favoris"
    )
  end

  def profil_seen
    @receiver = params[:receiver]
    @sender = params[:sender]
    # @admin = User.find_by(admin: true)

    mail(
      # to: @admin.email,
      to: @receiver.email,
      subject: "Votre profil sur SUNRYSE a été vu"
    )
  end

  def post_received
    @receiver = params[:receiver]
    @sender = params[:sender]
    # @admin = User.find_by(admin: true)

    mail(
      # to: @admin.email,
      to: @receiver.email,
      subject: "Vous avez reçu un message privé sur SUNRYSE"
    )
  end
end
