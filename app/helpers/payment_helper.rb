module PaymentHelper
  def multiplication(price,amount)
    return (price*amount).round(2)
  end

  def ispayment?
    payments = Payment.all
    return true if payments.detect{ |payment| payment.items.first.user == current_user }
    return false
  end
end
