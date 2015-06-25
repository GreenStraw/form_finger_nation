class UsersController < ApplicationController
  before_filter :validate_authorization_for_user, only: [:edit, :update]
  before_action :set_user, only: [:add_admin, :remove_admin]
  respond_to :html, :js
  load_and_authorize_resource

  def index
    respond_with @users
  end
  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def add_admin
    if !@user.has_role?(:admin)
      @user.add_role(:admin)
    end
    respond_to do |format|
      format.js { render action: 'admin' }
    end
  end

  def remove_admin
    if @user.has_role?(:admin)
      @user.remove_role(:admin)
    end
    respond_to do |format|
      format.js { render action: 'admin' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:user_id])
    end

    def validate_authorization_for_user
       redirect_to root_path unless @user == current_user
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:id, :username, :first_name, :last_name, :image_url, :email, :current_password, :password, :password_confirmation, :favorite_team_id, :about, :website, :gender, :uid, :provider, :address, {:sport_ids=>[], :team_ids=>[], :venue_ids=>[], :reservation_ids=>[], :endorsing_team_ids=>[], :follower_ids=>[], :followee_ids=>[]}, address_attributes: [:street1, :street2, :city, :state, :zip])
    end
end
