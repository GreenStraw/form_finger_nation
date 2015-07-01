class VenuesController < ApplicationController
  respond_to :html, :js
  before_action :set_venue, only: [:show, :edit, :update, :destroy]
  before_action :set_party, only: [:verify_party, :unverify_party]
  load_and_authorize_resource :venue
  load_and_authorize_resource :user
  load_and_authorize_resource :party
  before_action :authenticate_user!

  # GET /venues
  def index
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
  end

  # POST /venues
  def create
    if @venue.save
      redirect_to @venue, notice: 'Venue was successfully created.'
    else
      render :new
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
    if !@user.has_role?(:venue_manager, @venue)
      @user.add_role(:venue_manager, @venue)
    end
    respond_to do |format|
      format.js { render action: 'manager' }
    end
  end

  def remove_manager
    if @user.has_role?(:venue_manager, @venue)
      @user.remove_role(:venue_manager, @venue)
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
