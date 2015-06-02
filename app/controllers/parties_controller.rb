class PartiesController < ApplicationController
  respond_to :html, :js
  before_action :set_party, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :party
  load_and_authorize_resource :party_package, only: [:purchase_package, :zooz_transaction]
  before_action :authenticate_user!

  # GET /parties
  def index
    @user = current_user
  end

  def myparties
    
  end

  def n_sign_up
    sign_out current_user
    redirect_to new_user_registration_path
  end
  
  def search
    if params[:party].nil?
      params[:party] = {}
    end
    if params[:party][:search_location].nil?
      ip_lat_lng = if location.present?
        location.data['zipcode']
      else
        nil
      end
      params[:party][:search_location] = ip_lat_lng
    end
    if params[:party][:search_location].nil?
      @parties = []
    else
      search_results = Party.search_by_params(params[:party])
      # search_by_params returns [parties, teams, people].  We only care about parties here
      @parties = search_results[0]
      @venues = @parties.map(&:venue)
      @map_markers = Gmaps4rails.build_markers(@venues) do |venue, marker|
        marker.lat venue.address.latitude
        marker.lng venue.address.longitude
        marker.infowindow render_to_string(partial: '/venues/parties_info_window', locals: { venue: venue, parties: venue.upcoming_parties } )
      end
      #get search location so we can show the area even if there are no results
      @location = Address.get_coords(search_results[3])
    end
    respond_with @parties
  end

  # GET /parties/1
  def show
    @map_markers = Party.build_markers([@party])
  end

  # GET /parties/new
  def new
  end

  # GET /parties/1/edit
  def edit
  end

  # POST /parties
  def create
    @party.save
    current_user.party_reservations.create(party_id: @party.id, email: current_user.email)
    respond_with @party
  end

  # PATCH/PUT /parties/1
  def update
    flash[:success] = 'Party was successfully updated.' if @party.update(party_params)
    respond_with @party
  end

  # DELETE /parties/1
  def destroy
    flash[:success] = 'Party was successfully destroyed.' if @party.destroy
    respond_with @party
  end

  def purchase_package

  end

  def party_rsvp
    rsvp = current_user.party_reservations.where(user_id: current_user.id, party_id: @party.id).first
    if rsvp.blank?
      current_user.party_reservations.create( party_id: @party.id, email: current_user.email)
      flash[:success] = "Created reservation for #{@party.name}!"
    else
      rsvp.destroy
      flash[:success] = "Deleted reservation for #{@party.name}!"
    end
    redirect_to party_path(@party)
  end

  def invite_friends
  end

  def send_invites
    warning, success = @party.handle_invites(params, current_user)
    unless warning.blank?
      flash[:warning] = warning
    end
    unless success.blank?
      flash[:success] = success
    end
    redirect_to party_path(@party)
  end


  def zooz_transaction
    if params[:cmd]
      #This just tells zooz to initiate the payment process
      post_params = {cmd: "openTrx", amount: @party_package.package.price, currency_code: "USD"}
      result = Package.zooz_submit(post_params)
      #result is the session token
      render :json => {:token => result}
    else
      if params[:statusCode] == "0"
        @party = @party_package.party
        @package = @party_package.package
        @voucher = Voucher.create(transaction_display_id: params[:transactionDisplayID], transaction_id: params[:trxId], user_id: current_user.id, package_id: @package.id,  party_id: @party.id)
        flash[:notice] = "You have purchased #{@package.name}, Your transaction is #{params[:transactionDisplayID]}"
      else
        flash[:error] = "Error processing the credit card"
      end
      redirect_to "/parties/#{@party.id.to_s}"
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_party
      @party = Party.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def party_params
      params.require(:party).permit(:name, :description, :is_private, :verified, :scheduled_for, :organizer_id, :team_id, :venue_id, :search_item, :search_location, :venue, [venue_attributes: [:name, :description, :address, [address_attributes: [:street1, :street2, :city, :state, :zip]]]])
    end
end
