module OrderHelper
  # state
  def order_state_wait
    'paiement en attente'
  end

  def order_state_payed
    'payé'
  end

  # order_type
  def order_type_one_shot
    'unique'
  end

  def order_type_subscription
    'abonnement'
  end

  def order_type_camera
    'caméra'
  end

  # duration
  def one_week
    '1 semaine'
  end

  def one_month
    '1 mois'
  end

  def three_month
    '3 mois minimum'
  end

  def six_month
    '6 mois minimum'
  end

  # duratrion for camera
  def thirty_minutes
    '30 minutes'
  end

  # amount_cents
  def one_week_price
    5
  end

  def one_month_price
    15
  end

  def three_month_price
    12
  end

  def six_month_price
    10
  end

  # price per 30 minutes
  def camera_price
    0.50
  end
end
