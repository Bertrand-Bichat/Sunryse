module PaymentIntentHelper
  # refund status
  def succeeded
    'succeeded'
  end

  def pending
    'pending'
  end

  def failed
    'failed'
  end

  def canceled
    'canceled'
  end
end
