class AccountController < ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:user][:id])  
    unless params[:user][:password].blank? 
      if @user.update_attributes(user_params) &&  @user.update_attributes(password: params[:user][:password], password_confirmation: params[:user][:password])
        redirect_to account_path
      else
        render :edit
      end    
    else
      if @user.update_attributes(user_params)
        redirect_to account_path
      else
        render :edit
      end      
    end
  end
  
  
  private
  
  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:name, :first_name, :last_name, :username, :email, :provider, :uid, :customer_id, :facebook_access_token, :image_url)
  end
  
end
