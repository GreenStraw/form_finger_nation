class AccountController < ApplicationController
  
  def new
    @account = User.new
  end
  
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:user][:id]) 
     
    unless params[:user][:password].blank?      
      result = @user.update_attributes(user_params)
    else
      result = @user.update_attributes(user_params.except(:password, :password_confirmation))      
    end
    if result == true && params[:user][:password].blank?
      flash[:success] = "Your account details have been updated."
      redirect_to account_path
    elsif result == true
      #changing the password seems to kill the session??
      flash[:success] = "Your password has been changed, please log in with your new password."
      redirect_to root_path
    else
      flash[:warning] = "We could not update your account."
      render :edit
    end
  end
  
  def create
    @account = User.new(user_params)
    if @account.save_and_invite_member()
      flash[:success] = "Thanks for signing up! Check your email, #{@account.email}, for a confirmation link."
      redirect_to root_path
    else
      flash[:warning] = "errors occurred!"
      render :new, layout: "sign"
    end
  end
  
  
  private
  
  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:id, :name, :first_name, :last_name, :username, :email, :provider, :uid, :customer_id, :facebook_access_token, :image_url, :password, :password_confirmation)
  end
  
end
