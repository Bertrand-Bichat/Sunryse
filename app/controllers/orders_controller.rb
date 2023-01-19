class OrdersController < ApplicationController
  skip_before_action :test_user_authorization

  def filtered_index
    @paid_orders = authorize policy_scope(Order).includes(:user).where(state: helpers.order_state_payed, user: current_user).order(id: :desc).paginate(page: params[:page], per_page: 50)
  end

  def basket
    @waiting_orders = authorize policy_scope(Order).includes(:user).where(state: helpers.order_state_wait, user: current_user).order(id: :desc).paginate(page: params[:page], per_page: 50)
  end

  def choose_prices
    authorize :order, :choose_prices?
  end

  def current_order
    @duration = params[:duration]
    @order_type = params[:order_type]
    @user_id = params[:user_id].to_i
    @camera_credits = params[:camera_credits].to_i
    @amount = params[:amount].to_f
    @amount_cents = @amount * 100

    @order = authorize Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user
    @order.state = helpers.order_state_wait
    authorize @order
    active_order = policy_scope(Order).find_by(user: current_user, active: true)

    if (@order.order_type != helpers.order_type_camera) && active_order.present?
      return redirect_back fallback_location: home_path, alert: "Vous avez déjà une commande active. Veuillez attendre qu'elle soit terminée avant d'en souscrire une autre."
    elsif @order.save
      # check if customer exists in stripe (if not, create it)
      customer_in_stripe(@order.user)

      # create a stripe session
      if @order.order_type == helpers.order_type_one_shot
        session = create_stripe_session_one_shot(@order)
      elsif @order.order_type == helpers.order_type_subscription
        if @order.duration == helpers.three_month
          session = create_stripe_session_subscription(@order, ENV['STRIPE_PRICE_3_MONTHS'])
        elsif @order.duration == helpers.six_month
          session = create_stripe_session_subscription(@order, ENV['STRIPE_PRICE_6_MONTHS'])
        end
      elsif @order.order_type == helpers.order_type_camera
        session = create_stripe_session_one_shot(@order)
      end

      # affect the stripe session to the order
      @order.update(checkout_session_id: session.id)

      # redirect to payment page
      redirect_to new_order_payment_path(@order)
    else
      redirect_back fallback_location: home_path, alert: 'Erreur de saisie'
    end
  end

  # methode appelee quand un client paye une commande 'en attente'
  def pay_order
    @order = authorize policy_scope(Order).find(params[:id])
    active_order = policy_scope(Order).find_by(user: current_user, active: true)

    if (@order.order_type != helpers.order_type_camera) && active_order.present?
      return redirect_back fallback_location: home_path, alert: "Vous avez déjà une commande active. Veuillez attendre qu'elle soit terminée avant d'en souscrire à une autre."
    else
      customer_in_stripe(@order.user)

      if @order.order_type == helpers.order_type_one_shot
        session = create_stripe_session_one_shot(@order)
      elsif @order.order_type == helpers.order_type_subscription
        if @order.duration == helpers.three_month
          session = create_stripe_session_subscription(@order, ENV['STRIPE_PRICE_3_MONTHS'])
        elsif @order.duration == helpers.six_month
          session = create_stripe_session_subscription(@order, ENV['STRIPE_PRICE_6_MONTHS'])
        end
      elsif @order.order_type == helpers.order_type_camera
        session = create_stripe_session_one_shot(@order)
      end
    end

    @order.update(checkout_session_id: session.id)
    redirect_to new_order_payment_path(@order)
  end

  def destroy
    @order = authorize policy_scope(Order).find(params[:id])
    @order.destroy

    respond_to do |format|
      format.js
      format.html { redirect_back fallback_location: orders_path, notice: 'Votre commande a bien été annulée.' }
    end
  end

  def unsubcribed
    @order = authorize policy_scope(Order).find(params[:order_id])
    @subscription_id = @order.subscription_id
    @subscription = Stripe::Subscription.retrieve(@subscription_id) if @subscription_id

    if @subscription_id && @subscription
      @order.update(unsubscribed: true)
      UnauthorizeUserJob.set(wait: ((Date.today.at_beginning_of_month.next_month - Date.today).to_i + @order.paid_date.day - 1).days).perform_later(@order.user, @order)
      OrderMailer.with(order: @order).notification_unsubcribed.deliver_later
      Stripe::Subscription.delete(@subscription_id)
      return redirect_back fallback_location: orders_path, notice: "Votre abonnement sera bien résilié à la fin du mois en cours."
    end

    redirect_back fallback_location: orders_path, alert: "Erreur"
  end

  private

  def order_params
    params.require(:order).permit(
      :amount_cents,
      :duration,
      :camera_credits,
      :order_type
    )
  end

  # permet de retrouver le profil client lier a Stripe s'il existe, sinon, il en creer un
  def customer_in_stripe(user)
    stripe_id = user.stripe_id
    if stripe_id
      # retrieve stripe user id
      Stripe::Customer.retrieve(stripe_id)
    else
      # create new customer in stripe
      new_customer = Stripe::Customer.create({
        email: user.email,
        name: "#{user.pseudo}"
      })
      # update db user with stripe_id
      user.update(stripe_id: new_customer.id)
    end
  end

  # permet de creer une session de paiement one-shot
  def create_stripe_session_one_shot(order)
    Stripe::Checkout::Session.create(
      billing_address_collection: 'required',
      payment_method_types: ['card'],
      customer: order.user.stripe_id,
      line_items: [{
        name: (order.order_type == helpers.order_type_camera) ? "#{order.camera_credits} crédits d'échange par caméra" : order.duration,
        amount: order.amount_cents,
        currency: 'eur',
        quantity: 1
      }],
      mode: 'payment',
      success_url: orders_url,
      cancel_url: basket_url
    )
  end

  def create_stripe_session_subscription(order, stripe_price)
    Stripe::Checkout::Session.create(
      billing_address_collection: 'required',
      payment_method_types: ['card'],
      customer: order.user.stripe_id,
      line_items: [{
        price: stripe_price,
        quantity: 1
      }],
      mode: 'subscription',
      success_url: orders_url,
      cancel_url: basket_url
    )
  end
end
