class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "you have successfully logged in"
      redirect_to users_path
    else
      flash.now[:danger] = "There was something wrong with your login information"
      render 'new'
    end

    session[:cart].each do |product_id, amounts|
      item = current_user.items.find_by(product_id: product_id)
      if item != nil
        item.amounts = amounts
        item.save
      else
        current_user.items.build(product_id: product_id).save
      end
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "you have logged out "
    redirect_to root_path
    session[:cart] = {}
  end
end
