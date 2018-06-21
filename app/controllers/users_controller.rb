class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def index 
    #@users = User.all
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    if current_user.blank?
      @user = User.new
    else
      redirect_to root_path
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.name.capitalize} to onlineShop app!"
      redirect_to products_path
    else 
      render 'new'
    end
  end
   
  
  def edit
  
  end
  
  def update
    binding.pry
    if @user.update(user_params)
      flash[:success] = "your account was updated successfully"
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy

  end


  def forgot_password
    if request.post?
      @user = User.find_by(email: params[:user][:email])
      if @user.present?
        ResetPasswordMailer.reset_password(@user).deliver!
        flash[:success] = "send email successful"
        redirect_to login_path
      else
        flash[:notice] = "Email not exist"
        redirect_to forgot_password_users_path
      end
    end
  end


  def edit_password_reset
    if request.post?
      user = User.find(params[:edit_password_reset][:user_id])
      user.password = params[:edit_password_reset][:password]
      if user.save
        flash[:success] = "Change password success"
        redirect_to login_path
      else
        flash[:notice] = "There was something wrong"
        redirect_to edit_password_reset_users_path
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone, :address)
  end

  def set_user
    @user = User.find(params[:id])
  end
end