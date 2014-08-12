class SessionsController < ApplicationController
  def create
    omniauth_auth = request.env["rack.session"]["omniauth"]
    byebug
    user = User.from_omniauth(request.env["omniauth.auth"])
    unless user.blank?
      session[:user_id] = user.id
    else
      flash[:error] = "There was an issue logging into Facebook, please try again"
    end
      redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end