class UserMailer < ApplicationMailer
  def notification_welcome
    @user = params[:user]
    # @admin = User.find_by(admin: true)

    mail(
      to: @user.email,
      subject: 'Bienvenue sur Sunryse !'
    )
  end
end
