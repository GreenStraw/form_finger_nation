class AccountController < ApplicationController
  before_action :authenticate_user!, :only => [:show]
  def show
    @user = current_user
  end

  def new
    @user = User.new
  end

  def n_sign_up
    sign_out current_user
    redirect_to new_user_registration_path
  end

  def create
    @account = User.new(user_params)
    if @account.save_and_invite_member
      @account.send_welcome_email

      puts "request.location.city"*10
      # puts request.location.city
      puts request.to_yaml
      # puts request.location.region_name
      
      a_city = request.location.city rescue ''
      a_state = request.location.region_name rescue ''
      @account.address.update_columns(city: a_city, state: a_state) if @account.address.present?
      puts "request.location.region_name"*10
      flash[:success] = "Thanks for signing up! Check your email, #{@account.email}, for a confirmation link."
      redirect_to root_path
    else
      flash[:warning] = @account.errors.full_messages
      redirect_to new_user_registration_path
    end
  end

  def user
    @u = User.find(params[:id])
    @created_parties = @u.parties
    @rvs_parties = @u.party_reservations
    @teams = @u.followed_teams.order("name ASC")
  end

  def update_profile_picture
    @u = User.find(params[:id])
    @u.banner = params[:banner]
    if @u.update_attributes(user_params)
      redirect_to controller: :account, action: :user, :id => @u.id
      #render action: :user, notice: 'User was successfully updated.'
    else
      render action: :user, notice: 'Technical problem, Try again later.'
    end
  end

  def user_loc
    u = User.find(params[:id])
    u.address.city = params[:city] if u
    u.address.state = params[:state] if u
    u.address.save!

    respond_to do |format|
      format.js { render json: {}, status: 200 }
    end
  end
  
  def edit
    @user = current_user
    @teams = @user.followed_teams.order("name ASC")
    if @user.website == ''
      @user.website = 'http://'
    end
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

  private

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(
      :banner, 
      :id, 
      :name, 
      :favorite_team_id, 
      :about, 
      :website, 
      :gender, 
      :first_name, 
      :last_name, 
      :username, 
      :email, 
      :provider, 
      :uid, 
      :customer_id, 
      :facebook_access_token, 
      :image_url, 
      :password, 
      :password_confirmation, 
      :requested_role,
      :ph_number,
      address_attributes: [
          :street1, 
          :street2, 
          :city, 
          :state, 
          :zip,
          :ph_number,
        ] )
  end

end
