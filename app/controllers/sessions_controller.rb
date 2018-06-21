class SessionsController < ApplicationController
  def new
    if current_user.present?
      redirect_to root_path
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      cookies.signed[:user_id] = user.id
      flash[:success] = "you have successfully logged in"
      session[:cart].each do |product_id, amounts|
        item = Item.find_by(product_id: product_id, user_id: user.id, ispayment: false)
        if item.blank?
          current_user.items.build(product_id: product_id, amounts: amounts).save 
        else
          item.amounts += amounts.to_i
          item.save  
        end
      end
      redirect_to users_path
      session[:cart] = {}
    else
      flash.now[:danger] = "There was something wrong with your login information"
      render 'new'
    end


  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "you have logged out "
    redirect_to root_path
  end
end
