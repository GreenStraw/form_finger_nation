class PartiesController < ApplicationController
  respond_to :html, :js
  before_action :set_party, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :party, :except=>[:cancel_reservation, :ajaxsearch]
  load_and_authorize_resource :party_package, only: [:purchase_package, :zooz_transaction]
  before_action :authenticate_user!

  # GET /parties
  def index
    $c = 0
    @user = current_user
    @rvs_parties = @user.party_reservations
    @created_parties = @user.parties
    @teams = @user.followed_teams
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

  def ajaxsearch
    $c = 0
    # search_results = Party.search_by_params(params[:party])
    # @rvs_parties = current_user.party_reservations.where("name LIKE ? or description LIKE ?","%#{params[:keyword]}%","%#{params[:keyword]}%")
    key = "%#{params[:keyword]}%"
    key = key.downcase
    # @created_parties = current_user.parties.where("parties.name LIKE ? or parties.description LIKE ?" , key, key)
    # @created_parties = current_user.parties.joins(:venue, :team, :sport).where("parties.name LIKE ? or parties.description LIKE ? or venues.name LIKE ? or venues.description LIKE ? or teams.name LIKE ?  or sports.name LIKE ?" , key, key, key, key, key, key)
    @created_parties = current_user.parties.joins("LEFT OUTER JOIN venues ON parties.venue_id = venues.id LEFT OUTER JOIN teams ON parties.team_id = teams.id LEFT OUTER JOIN sports on parties.sport_id = sports.id").where("parties.name ILIKE ? or parties.description ILIKE ? or venues.address.city_state ILIKE ? or venues.description ILIKE ? or teams.name ILIKE ?  or sports.name ILIKE ?" , key, key, key, key, key, key)
    # @rvs_parties = current_user.party_reservations.party.joins("LEFT OUTER JOIN venues ON parties.venue_id = venues.id LEFT OUTER JOIN teams ON parties.team_id = teams.id LEFT OUTER JOIN sports on parties.sport_id = sports.id").where("parties.name LIKE ? or parties.description LIKE ? or venues.name LIKE ? or venues.description LIKE ? or teams.name LIKE ?  or sports.name LIKE ?" , key, key, key, key, key, key)
    puts '-'*80
    puts @created_parties.inspect
    puts '-'*80
    puts @created_parties.length
    puts '-'*80
    respond_to do |format|
      format.js
      format.json { render json: {created_parties: @created_parties} }  # respond with the created JSON object
    end
  end

  def get_team_parties
    $c = 0
    @created_parties = Team.find(params[:team]).parties    
    respond_to do |format|
      format.js
      format.json { render json: {created_parties: @created_parties} }  # respond with the created JSON object
    end
  end

  def check_friendly_url_availablitiy
    party = Party.find_by_friendly_url(params[:friendlyUrl])
    value = party.present?
    respond_to do |format|
      format.json {render json: value}
    end
  end

  # GET /parties/1
  def show
    @map_markers = Party.build_markers([@party])
  end

  # GET /parties/new
  def new
  end

  def cant_find
    
  end

  # GET /parties/1/edit
  def edit
  end

  # POST /parties
  def create
    to_date = DateTime.strptime(params[:party][:scheduled_for],'%m/%d/%Y').strftime("%Y-%m-%d")
    date_s = to_date.to_s << ' ' << params[:party][:hid_time] << ':00'
    params[:party][:scheduled_for] = ''
    @party.save
    @party.update_column("scheduled_for", DateTime.parse(date_s))
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

  def cancel_reservation
    p = PartyReservation.find(params[:id])
    flash[:success] = 'Successfully destroyed.' if p.destroy
    redirect_to :back
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
      @party = Party.find_by_friendly_url(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def party_params
      params.require(:party).permit(:name, :description, :is_private, :verified, :scheduled_for, :organizer_id, :team_id, :venue_id, :search_item, :search_location,:friendly_url ,:slug ,:venue, [venue_attributes: [:name, :description, :address, [address_attributes: [:street1, :street2, :city, :state, :zip]]]])
    end
end
