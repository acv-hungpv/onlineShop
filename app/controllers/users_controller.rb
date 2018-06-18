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

  def get_forgot_password

  end

  def post_forgot_password
    @user = User.find_by(email: params[:user][:email])
  
    if @user.present?
      ResetPasswordMailer.reset_password(@user).deliver!
      flash[:success] = "send email successful"
      redirect_to login_path
    else
      flash[:notice] = "Email not exist"
      redirect_to get_forgot_password_users_path
    end
  end

  def get_edit_password_reset

  end

  def post_edit_password_reset
    user = User.find(params[:edit_password_reset][:user_id])
    user.password = params[:edit_password_reset][:password]
    if user.save
      flash[:success] = "Change password success"
      redirect_to login_path
    else
      flash[:notice] = "There was something wrong"
      redirect_to get_edit_password_reset_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end