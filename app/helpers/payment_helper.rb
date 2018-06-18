module PaymentHelper
  def multiplication(price,amount)
    return (price*amount).round(2)
  end

  def ispayment?
    payments = Payment.all
    return true if payments.detect{ |payment| payment.items.first.user == current_user }
    return false
  end

  def total_money_in_items(items)
    total = 0 
    items.each do |i|
      total += i.amounts*i.product.price
    end
    return total.round(2)
  end
end
