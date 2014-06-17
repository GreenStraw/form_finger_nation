class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!

  def welcome
  end

  def index
    if user_signed_in?
      authenticate_tenant!
      render :welcome
    else
      flash[:notice] = "sign in if your organization has an account" if flash[:notice].blank?
    end   # if logged in .. else first time
  end
  
  def privacy
  end
  
  def terms
  end
  
end
