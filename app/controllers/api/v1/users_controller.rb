class Api::V1::UsersController < Api::V1::BaseController
  include Devise::Models::DatabaseAuthenticatable
  include ActiveRecord::AttributeAssignment
  before_filter :authenticate_user_from_token!, except: [:create]
  load_and_authorize_resource except: [:create]

  def index
    respond_with @user=User.all
  end

  def show
    respond_with @user
  end

  def update
    if changing_password
      update_with_password
    else
      update_without_password
    end
  end

  def follow_user
    @followee = User.find(params[:user_id])
    if !@user.followees.include?(@followee)
      @user.followees << @followee
    end
    respond_with @user, :location=>api_v1_users_path
  end

  def unfollow_user
    @followee = User.find(params[:user_id])
    if @user.followees.include?(@followee)
      @user.followees.delete(@followee)
    end
    respond_with @user, :location=>api_v1_users_path
  end

  def search_users
    username = params[:username] if params[:username]
    search_location = params[:search_location] if params[:search_location]
    radius = params[:radius] if params[:radius]
    team_id = params[:team_id] if params[:team_id]
    search_results = users_in_the_area(search_location, radius)
    if username
      search_results = search_results & have_name_like(username)
    end
    if team_id
      search_results = search_results & are_fans_of(team_id)
    end
    return render json: search_results
  end

  private



  def are_fans_of(team_id)
    Favorite.where('favoritable_id = ? and favoriter_type = ? and favoritable_type = ?', team_id, "User", "Team").map(&:favoriter_id)
  end

  def have_name_like(username)
    User.where("username ilike ?", "%#{username}%").map(&:id)
  end

  def users_in_the_area(search_location, radius)
    loc = search_location
    rad = radius || 20
    addresses = Address.near(loc, rad).to_a
    if addresses.any?
      user_ids =  addresses.select{|a| a.addressable_type=='User'}.to_a.map(&:addressable_id)
    end
    return user_ids || []
  end

  def changing_password
    user_params[:current_password].present? && user_params[:password].present? && user_params[:password_confirmation].present?
  end

  def update_without_password
    if @user.update(user_params)
      respond_with @user
    else
      return render json: { :errors => @user.errors }, status: 422
    end
  end

  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :email, :current_password, :password, :password_confirmation, :uid, :provider, :address, {:sport_ids=>[], :team_ids=>[], :venue_ids=>[], :reservation_ids=>[], :endorsing_team_ids=>[], :follower_ids=>[], :followee_ids=>[]}, address_attributes: [:street1, :street2, :city, :state, :zip])
  end

  def update_with_password(*options)
    current_password = user_params.delete(:current_password)

    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation) if user_params[:password_confirmation].blank?
    end

    if valid_password?(current_password)
      @user.update_attributes(user_params, *options)
      clean_up_passwords
      return render json: @user, status: 204
    else
      @user.assign_attributes(user_params, *options)
      @user.valid?
      @user.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      clean_up_passwords
      return render json: @user.errors.messages, status: 422
    end
  end

  def valid_password?(password)
    return false if @user.encrypted_password.blank?
    bcrypt   = ::BCrypt::Password.new(@user.encrypted_password)
    password = ::BCrypt::Engine.hash_secret("#{password}#{self.class.pepper}", bcrypt.salt)
    Devise.secure_compare(password, @user.encrypted_password)
  end

end
