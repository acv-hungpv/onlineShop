class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  helper_method :current_user, :logged_in?,
                :find_item_in_addcart,
                :is_item_to_show_content_in_cart?,
                :total_money_in_payment
  def total_money_in_payment(payment)
    total = 0
    payment.items.each do |item|
      total += item.amounts*item.product.price
    end
    return total
  end

  def is_item_to_show_content_in_cart?
    return current_user.items.pluck(:ispayment).count(false) > 0
  end

  def find_item_in_addcart(product_id)
    return current_user.items.detect{|item| item.ispayment == false && item.product_id == product_id}
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "you must be logged in to performce that action"
      redirect_to root_path
    end
  end
end
