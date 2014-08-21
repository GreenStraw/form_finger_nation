class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!

  def about
  end

  def contact
  end

  def faq
  end

  def home
    @user = current_user
  end

  def how
  end
  
  def jobs
  end
  
  def privacy
  end

  def terms
  end
  
end
