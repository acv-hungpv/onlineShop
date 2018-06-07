class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def index 
    #@users = User.all
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @user = User.new
  end
  
  def create
    debugger
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.name.capitalize} to onlineShop app!"
      redirect_to user_path(@user)
    else 
      render 'new'
    end
  end
   
  
  def edit
  
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "your account was updated successfully"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy

  end

  def addcart
    @product_id = params[:product_id]
    if current_user != nil
      if current_user.items.count == 0 || current_user.items.find_by(product_id: @product_id) == nil
        current_user.items.build(product_id: @product_id).save!
      else 
        current_item = current_user.items.find_by(product_id: @product_id)
        current_item.amounts += 1
        current_item.save
      end
    end
  end

  def cart

  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end