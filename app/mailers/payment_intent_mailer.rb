class PaymentIntentMailer < ApplicationMailer
  def notification_refund
    @order = params[:order]
    @payment_intent = params[:payment_intent]
    @customer = @order.user
    # @admin = User.find_by(admin: true)

    mail(
      # to: @admin.email,
      to: @customer.email,
      subject: 'Confirmation de votre remboursement par SUNRYSE'
    )
  end
end
