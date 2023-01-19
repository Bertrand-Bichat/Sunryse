class PaymentIntentsController < ApplicationController

  def filtered_index
    @order = policy_scope(Order).find(params[:order_id])
    @payment_intents = authorize @order.payment_intents.order(id: :desc)
  end

  def refund
    @order = policy_scope(Order).find(params[:order_id])
    @payment_intent = authorize @order.payment_intents.find(params[:id])
    @stripe_payment_intent = Stripe::PaymentIntent.retrieve(@payment_intent.payment_intent_id)

    if @stripe_payment_intent.present?
      @refund = Stripe::Refund.create({ payment_intent: @stripe_payment_intent.id })
      @payment_intent.update(refund_id: @refund.id, refund_status: @refund.status)
      if @refund.status == helpers.succeeded
        PaymentIntentMailer.with(order: @order, payment_intent: @payment_intent).notification_refund.deliver_later
      end
      return redirect_to payment_intents_path(order_id: @order.id, anchor: "payment-intent-#{@payment_intent.id}"), notice: "Le remboursement a bien été pris en compte."
    end

    redirect_to payment_intents_path(order_id: @order.id, anchor: "payment-intent-#{@payment_intent.id}"), alert: "Le paiement n'est pas connu dans Stripe. Le remboursement n'a pas été pris en compte."
  end

  def check_refund_status
    @payment_intent = authorize policy_scope(PaymentIntent).find(params[:id])
    @refund = Stripe::Refund.retrieve(@payment_intent.refund_id)

    if @refund.present? && (@refund.status != @payment_intent.refund_status)
      @payment_intent.update(refund_status: @refund.status)
      if @refund.status == helpers.succeeded
        PaymentIntentMailer.with(order: @payment_intent.order, payment_intent: @payment_intent).notification_refund.deliver_later
      end
      return redirect_to payment_intents_path(order_id: @payment_intent.order.id, anchor: "payment-intent-#{@payment_intent.id}"), notice: "Le statut du remboursement a bien été mis à jour."
    end

    redirect_to payment_intents_path(order_id: @payment_intent.order.id, anchor: "payment-intent-#{@payment_intent.id}"), alert: "Le remboursement n'est pas connu dans Stripe."
  end
end
