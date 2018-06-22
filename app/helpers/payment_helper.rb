module PaymentHelper
  
  def total_money_in_payment(payment)
    payment.items.includes(:product).inject(0) { |sum,item| sum += (item.amounts*item.product.price) }.round(2)
  end

  def multiplication(price,amount)
    return (price*amount).round(2)
  end

  def ispayment?
    payments = Payment.all
    return true if payments.includes(:items).detect{ |payment| payment.items.present? && payment.items.includes(:user).first.user == current_user }
    return false
  end

  def total_money_in_items(items)
    items.includes(:product).inject(0) { |total, i| total += i.amounts*i.product.price }.round(2)
  end

  def is_valid_to_show_payment_current_user?(payment)
    return true if payment.items.present? && current_user == payment.items.includes(:user).first.user
    return false
  end

  def eager_load_payment_items(items)
    return items.includes(:product)
  end
end
