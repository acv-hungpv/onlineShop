module PaymentHelper
  
  def total_money_in_payment(payment)
    payment.items.inject(0) { |sum,item| sum + (item.amounts*item.product.price) }
  end

  def multiplication(price,amount)
    return (price*amount).round(2)
  end

  def ispayment?
    payments = Payment.all
    return true if payments.detect{ |payment| payment.items.first.user == current_user }
    return false
  end

  def total_money_in_items(items)
    items.inject(0) { |total, i| total + i.amounts*i.product.price }
  end
end
