require 'stripe'

Rails.configuration.stripe = {
  publishable_key:   ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key:        ENV['STRIPE_SECRET_KEY'],
  signing_secret:    ENV['STRIPE_WEBHOOK_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|

  # events stripe liés aux sessions de paiements réussies (checkout session)
  events.subscribe 'checkout.session.completed' do |event|

    # récupère l'id généré par Stripe de l'event
    event_id = event.id

    # si l'event n'est pas encore dans la database, on autorise les actions liées au webhook
    if !Event.find_by(stripe_id: event_id).present?

      # on récupère la session
      session = event.data.object

      # récupère l'order qui vient d'être payée
      order = Order.find_by(checkout_session_id: session.id)
      user = order.user

      # confirme que l'order est bien payée
      order.update(state: ApplicationController.helpers.order_state_payed, paid_date: Date.today)

      # on crée un event en database avec event_id afin de ne pas répéter les actions liées au webhook
      # si le webhook renvoi plusieurs fois l'event
      Event.create!(stripe_id: event_id)

      # on récupère le payment_intent_id
      payment_intent_id = session.payment_intent

      # on créer le PaymentIntent associé, si l'id existe (one-shot & camera)
      if payment_intent_id
        PaymentIntent.create(order: order, payment_intent_id: payment_intent_id, amount_cents: order.amount_cents)
      end

      # one-shot payment
      if order.order_type == ApplicationController.helpers.order_type_one_shot
        order.update(active: true)
        user.update(authorized: true)

        if order.duration == ApplicationController.helpers.one_week
          UnauthorizeUserJob.set(wait: 8.days).perform_later(user, order)
        elsif order.duration == ApplicationController.helpers.one_month
          UnauthorizeUserJob.set(wait: 1.month).perform_later(user, order)
        end

      # subscription payment
      elsif order.order_type == ApplicationController.helpers.order_type_subscription
        # on récupère l'id de la subscription
        # session = Stripe::Checkout::Session.retrieve(order.checkout_session_id)
        subscription_id = session.subscription

        if subscription_id
          # on actualise l'order avec l'id de la subscription
          order.update(subscription_id: subscription_id, active: true)
          user.update(authorized: true)

          # on récupère l'abonnement associé pour trouver sa dernière facture
          subscription = Stripe::Subscription.retrieve(subscription_id)
          latest_invoice_id = subscription.latest_invoice if subscription
          latest_invoice = Stripe::Invoice.retrieve(latest_invoice_id) if latest_invoice_id
          latest_payment_intent_id = latest_invoice.payment_intent if latest_invoice
          if latest_payment_intent_id
            PaymentIntent.create(order: order, payment_intent_id: latest_payment_intent_id, amount_cents: order.amount_cents)
          end
        end

      # camera payment
      elsif order.order_type == ApplicationController.helpers.order_type_camera
        # on récupère le nombre de crédits achetés
        credits_quantity = order.camera_credits

        if credits_quantity > 0
          new_credit = user.camera_credits_balance + credits_quantity
          user.update(camera_credits_balance: new_credit)
        end
      end

      # envoi du mail après paiement valide
      OrderMailer.with(order: order).notification_order_paid.deliver_later
    end

  end

  # events stripe liés aux invoices (factures) qui viennent de passer en statut 'paid' (payée)
  events.subscribe 'invoice.paid' do |event|

    # récupère l'id généré par Stripe de l'event
    event_id = event.id

    # si l'event n'est pas encore dans la database, on autorise les actions liées au webhook
    if !Event.find_by(stripe_id: event_id).present?

      # on crée un event en database avec event_id afin de ne pas répéter les actions liées au webhook, si le webhook renvoi plusieurs fois l'event
      Event.create!(stripe_id: event_id)

      # récupère l'invoice qui a déclenchée cet évènement
      invoice = event.data.object
      # récupère l'abonnement associé, s'il y en a un
      subscription_id = invoice.subscription
      # récupère l'order associée à cet abonnement, s'il y en a un
      order = Order.find_by(subscription_id: subscription_id, active: true) if subscription_id
      # nombre d'invoices liées à cet abonnement dont le statut est 'payé'

      if order && (order.order_type == ApplicationController.helpers.order_type_subscription)
        order.update(invoices_number: order.invoices_number + 1)
        all_paid_invoices_number = Stripe::Invoice.list({subscription: subscription_id, status: "paid"}).data.size if subscription_id

        if all_paid_invoices_number && (all_paid_invoices_number > 1)
          payment_intent_id = invoice.payment_intent
          if payment_intent_id
            PaymentIntent.create(order: order, payment_intent_id: payment_intent_id, amount_cents: order.amount_cents)
          end
          # OrderMailer.with(order: order).notification_invoice_paid.deliver_later
        end
      end

    end
  end
end

# Comment ajouter un endpoint sur le webhook du compte Stripe :

# Sur le dashboard Stripe, cliquer sur 'Développeurs' puis sur 'Webhooks'
# Activer 'Environnement de test' si on utilise les clés API Stripe de test
# Cliquer sur 'Ajouter un endpoint'
# Copier-collé l'adresse url de base du site, suivie de la route '/stripe-webhooks' (voir fichier routes.rb)
# exemple: 'https://www.sunryse.fr/stripe-webhooks'
# Dans 'Description', mettre un texte pour décrir ce que fais ce endpoint (optionnel)
# Dans 'Evenements à envoyer', sélectionner le ou les évènements que l'on veut suivre
# exemple pour ici: 'checkout.session.completed'
# Ensuite, sous 'Clé secrète', cliquer sur 'Cliquer pour révéler' afin de faire apparaitre une clé API spéciale webhook
# Copié-collé cette clé dans les 'Settings - Config Vars' du site sur Heroku (key = STRIPE_WEBHOOK_SECRET_KEY , value = clé)
# Vérifier que les 2 clés api STRIPE_PUBLISHABLE_KEY et STRIPE_SECRET_KEY sont bien enregistrées au même endroit sur Heroku
# ajouter au même endroit key = DOMAIN et value = www.sunryse.fr afin que la redirection après paiement se fasse sur le site en prod
# après avoir tout enregistré, rafraîchir la page internet https://www.sunryse.fr/ et tester l'achat d'un parcours pour voir si ça marche
# normalement, stripe redirige après paiement vers 'mes-commandes' et passe le state de l'order en 'Payé' et le status de la journey en 'En cours'
