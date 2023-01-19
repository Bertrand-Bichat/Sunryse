class OrderMailer < ApplicationMailer
  def notification_order_paid
    @order = params[:order]
    @customer = @order.user
    # @admin = User.find_by(admin: true)

    mail(
      # to: @admin.email,
      to: @customer.email,
      subject: 'Confirmation achat sur SUNRYSE'
    )
  end

  def notification_unsubcribed
    @order = params[:order]
    @customer = @order.user
    # @admin = User.find_by(admin: true)

    mail(
      # to: @admin.email,
      to: @customer.email,
      subject: 'Votre abonnement SUNRYSE sera résilié à la fin du mois'
    )
  end
end
