class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  helper_method :current_user, :logged_in?, :find_and_count_amount_product_in_items

  def find_and_count_amount_product_in_items(product_id)
    return current_user.items.find_by(product_id: product_id).amounts
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
