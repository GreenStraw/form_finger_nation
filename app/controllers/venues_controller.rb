class VenuesController < ApplicationController
  respond_to :html, :js
  before_action :set_venue, only: [:show, :edit, :update, :destroy]
  before_action :set_party, only: [:verify_party, :unverify_party]
  load_and_authorize_resource :venue
  load_and_authorize_resource :user
  load_and_authorize_resource :party
  before_action :authenticate_user!
  
  #before_action :does_user_have_access_vendor_view
  
  # GET /venues
  def index

    # Amount in cents
    #@amount = 500

    #customer = Stripe::Customer.create(
    #  :email => params[:stripeEmail],
    #  :source  => params[:stripeToken]
    #)

    charge = Stripe::Charge.create(
      customer: '111',
      amount: 300,
      description: 'Rails Stripe customer',
      currency: 'usd'
    )

    respond_with @venues
  end

  # GET /venues/1
  def show
    @map_markers = Gmaps4rails.build_markers(@venue) do |venue, marker|
      marker.lat venue.address.latitude
      marker.lng venue.address.longitude
    end
    respond_with @venue
  end

  # GET /venues/new
  def new
    @venue = Venue.new
  end

  # GET /venues/1/edit
  def edit
    if(params[:party_id].present?)
      @party = Party.find(params[:party_id])
      @flag = true
    end

    @party_exist = Party.party_exist?(@venue.id)
  end

  # POST /venues
  def create

    address_exist = Venue.addressExist?(@venue.address.longitude, @venue.address.latitude, @venue.address.street2)
    
    if !address_exist

      if @venue.save!
        # @user = User.find(current_user.id)
        if !current_user.has_role?(:venue_manager, @venue)
          role = Role.create(name: 'manager', resource_id: @venue.id, resource_type: "Venue")
          UsersRole.create(user_id: params[:user_id], role_id: role.id)
          # current_user.roles << role
          # current_user.add_role(:venue_manager, @venue)
        end
        redirect_to @venue, notice: 'Venue was successfully created.'
        
      else
        render :new
      end
    else
        redirect_to new_venue_path, notice: 'Address Already Exists'
    end
  end

  # PATCH/PUT /venues/1
  def update
    if @venue.update(venue_params)
      redirect_to @venue, notice: 'Venue was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /venues/1
  def destroy
    @venue.destroy
    redirect_to venues_url, notice: 'Venue was successfully deleted.'
  end

  def add_manager
    if !@user.has_role?(:manager, @venue)
      @user.add_role(:venue_manager, @venue)
    end
    respond_to do |format|
      format.js { render action: 'manager' }
    end
  end

  def remove_manager
    u_id = params[:user_id]
    user = User.find_by_id(u_id)

    if !user.has_role?(:manager, @venue)
      user.remove_role(:venue_manager, @venue)
    end
    respond_to do |format|
      format.js { render action: 'manager' }
    end
  end

  def verify_party
    @party.update_attribute(:verified, true)
    respond_with @venue
  end

  def unverify_party
    @party.update_attribute(:verified, false)
    respond_with @venue
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_venue
      @venue = Venue.find(params[:id])
    end

    def set_party
      @party = Party.find_by_friendly_url(params[:party_id])
    end

    # Only allow a trusted parameter "white list" through.
    def venue_params
      params.require(:venue).permit(:name, :description, :image_url, :user_id, :address, [address_attributes: [:street1, :street2, :city, :state, :zip]])
    end
end
