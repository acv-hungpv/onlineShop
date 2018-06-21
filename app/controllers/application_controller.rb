class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  helper_method :current_user, :logged_in?,
                :is_item_to_show_content_in_cart?


  def is_item_to_show_content_in_cart?
    return current_user.items.pluck(:ispayment).count(false) > 0
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
