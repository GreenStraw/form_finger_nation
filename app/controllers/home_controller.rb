class HomeController < ApplicationController
  skip_before_action :authenticate_tenant!
  
  def index
    #since this is the default route, and since it isn't used, we must be here because of an error
    #so redirect to the root path and show an error
    flash[:error] = "That page was not found!"
    redirect_to root_path
  end


  def become
    # p = Party.group(:organizer_id).count
    # puts p.to_yaml
    # Voucher.group(:user_id).count find(22)
    sign_in(:user, User.first)
    redirect_to root_path
  end

  def about
  end

  def contact
  end

  def faq
  end

  def home
    if current_user
      @user = current_user
    else
      @user = User.new
    end
  end

  def how
  end
  
  def jobs
  end
  
  def privacy
  end

  def terms
  end

  def about2
  end

end
