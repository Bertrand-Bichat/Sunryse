class PaymentsController < ApplicationController
  skip_before_action :test_user_authorization

  # methode appelée pour afficher la page blanche permettant de lancer la session Stripe
  # pour le client avec un addEventListener sur le chargement de la page
  def new
    @order = authorize policy_scope(Order).where(state: helpers.order_state_wait).find(params[:order_id])
  end
end
