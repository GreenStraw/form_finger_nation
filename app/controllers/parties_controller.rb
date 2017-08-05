class PartiesController < ApplicationController
  respond_to :html, :js
  before_action :set_party, only: [:show, :edit, :update, :destroy, :invite_friends, :party_rsvp, :send_invites, :verify, :unverify]
  load_and_authorize_resource :party, :except=>[:cancel_reservation, :ajaxsearch, :get_team_parties, :get_parties, :check_friendly_url_availablitiy, :cant_find]
  load_and_authorize_resource :party_package, only: [:purchase_package, :zooz_transaction]
  before_action :authenticate_user!

  # GET /parties
  def index
    $c = 0
    @user = current_user
    @rvs_parties = @user.party_reservations
    @created_parties = @user.parties
    @teams = @user.followed_teams.order("name ASC")
    @pending_parties = @user.get_pending_parties
    @accepted_parties = @user.get_accepted_parties
    # if @created_parties.blank?
    #   redirect_to cant_find_parties_path
    # end
  end

  def search
    if params[:party].nil?
      params[:party] = {}
    end
    # if params[:party][:search_location].nil?
    #   ip_lat_lng = current_user.address.city
    #   params[:party][:search_location] = ip_lat_lng
    #   if params[:party][:search_item].nil?
    #     params[:party][:search_item] = current_user.address.city
    #   end
    # end

    # if(params[:party][:search_item].nil?)
    #   params[:party][:search_item] = current_user.address.city
    # end
    
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
    @created_parties  = []
    result = current_user.parties.where("parties.name ILIKE ? or parties.description ILIKE ? ",key ,key)
    @created_parties.concat(result)
    venues = Venue.where("name ILIKE ?", key)
    venues.try(:each) do |venue|
      @created_parties.concat(venue.parties.where('parties.organizer_id = ? ', current_user.id) )
    end

    teams = Team.where("name ILIKE ?", key)
    teams.try(:each) do |team|
      @created_parties.concat(team.parties.where('parties.organizer_id = ? ', current_user.id) )
    end
    # @created_parties = current_user.parties.where("parties.name ILIKE ?", key)
    respond_to do |format|
      format.js
      format.json { render json: {created_parties: @created_parties} }  # respond with the created JSON object
    end
  end

  def get_parties
    @created_parties =  current_user.parties

    respond_to do |format|
      format.js
      format.json { render json: {created_parties: @created_parties} }  # respond with the created JSON object
    end

  end

  def get_team_parties
    $c = 0
    @created_parties = Team.find(params[:team]).parties.where('parties.organizer_id = ? ', current_user.id)
    @parties_location_distance = Hash.new
    @created_parties.each do |team_party|
      @rvs_party_city = team_party.venue.address.city
      if @parties_location_distance.key?(@rvs_party_city)
        @parties_location_distance[@rvs_party_city]+=1
      else
        @parties_location_distance[@rvs_party_city] = 1
      end
    end

    @user_coor = Geocoder.coordinates(current_user.address.city)

    @parties_location_distance.each do |key,value|
      @party_coor = Geocoder.coordinates(key)
      @parties_location_distance[key] = Address.distance_of_two_locations(@user_coor,@party_coor)
    end

    @sorted_distances = Hash[@parties_location_distance.sort_by{ |k,v| v }]

    cities_list = @sorted_distances.keys
    pr_ids = []
    cities_list.each do |c|
      party_ids = Team.find(params[:team]).parties.where('parties.organizer_id = ? ', current_user.id).pluck("id")
      parties = Party.where(id: party_ids)
      parties = parties.joins(venue: :address).where("addresses.city = ? ", c.to_s)

      pr = Team.find(params[:team]).parties.where(id: parties).pluck("id")
      pr_ids = pr_ids + pr   
    end
    @created_parties = Team.find(params[:team]).parties.where(id: pr_ids).sort_by{|p| pr_ids.index(p.id)}
    
    respond_to do |format|
      format.js
      format.json { render json: {created_parties: @created_parties} }  # respond with the created JSON object
    end
  end

  def get_team_rsvp_parties
    @user=current_user
    rvs_parties_ids = @user.party_reservations.pluck("party_id")
    @rvs_parties = Team.find(params[:team]).parties.where('parties.organizer_id = ? AND parties.id IN (?) ', current_user.id, rvs_parties_ids)
    cities_list = sort_parties_geographically(@rvs_parties)
    pr_ids = []
    cities_list.each do |c|
      party_ids = Team.find(params[:team]).parties.where('parties.organizer_id = ? AND parties.id IN (?) ', current_user.id, rvs_parties_ids).pluck("id")
      parties = Party.where(id: party_ids)
      parties = parties.joins(venue: :address).where("addresses.city = ? ", c.to_s)
      pr = Team.find(params[:team]).parties.where(id: parties).pluck("id")
      pr_ids = pr_ids + pr   
    end
    @created_parties = Team.find(params[:team]).parties.where(id: pr_ids).sort_by{|p| pr_ids.index(p.id)}
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
    to_date = ""
    Time.use_zone("Central Time (US & Canada)") do
      to_date = Time.zone.parse("2016-03-05 10:00")
    end

    @test = DateTime.strptime('08/05/2017','%m/%d/%Y').strftime("%Y-%m-%d")
    
    respond_with @party
  end

  def cant_find
    
  end

  # GET /parties/1/edit
  def edit
  end

  # POST /parties
  def create
    # to_date = DateTime.strptime(params[:party][:scheduled_for],'%m/%d/%Y').strftime("%Y-%m-%d")
    # render new_party_path

    #party_params[:who_created_location] = "customer_house" || party_params[:who_created_location] = "customer_venue" && party_params[:id] = "new_venue"

    params[:party][:verified] = false # default verified to false

    if current_user.has_role?(:venue_manager, :any) || current_user.has_role?(:manager, :any)
      params[:party][:who_created_location] = "venue_venue"
    end

    if params[:party][:who_created_location] = "venue_venue" || params[:party][:who_created_location] = "customer_venue" && params[:party][:id] != "new_venue"
      params[:party].delete(:venue_attributes)
      params[:party][:verified] = true
    end

    #params[:party]["scheduled_for(1i)"] = "2017"
    #params[:party]["scheduled_for(2i)"] = "8"
    #params[:party]["scheduled_for(3i)"] = "8"
    #params[:party]["scheduled_for(4i)"] = "13"
    #params[:party]["scheduled_for(5i)"] = "30"
    
    if @party = Party.create(party_params)

      @party.scheduled_for="2017-09-08 13:30"

      flash[:notice] = 'Party was successfully created.'
      @party.save(:validate => false)
      current_user.party_reservations.create(party_id: @party.id, email: current_user.email)
      respond_with @party, location: party_path(@party)

    else
      render new_party_path
    end

  end

  # PATCH/PUT /parties/1
  def update
    flash[:success] = 'Party was successfully updated.' if @party.update(party_params)
    @party.save
    respond_with @party
  end

  # DELETE /parties/1
  def destroy
    @party.party_reservations.destroy_all
    flash[:success] = 'Party was successfully deleted.' if @party.destroy
    respond_with @party
  end

  def cancel_reservation
    p = PartyReservation.find(params[:id])
    flash[:success] = 'Successfully deleted.' if p.destroy
    redirect_to :back
  end

  def purchase_package

  end

  def verify

    #default to grab first venue, but later we'll change when user can own multiple
    venue = current_user.managed_venues.first

    @party.update_attribute(:verified, true, :venue_id, venue.id)
    respond_with @party
  end

  def unverify
    @party.update_attribute(:verified, false)
    respond_with @party
  end

  def party_rsvp
    if params[:flag]
      @flag = true
    else
      @flag = false
    end
    rsvp = current_user.party_reservations.where(user_id: current_user.id, party_id: @party.id).first
    if rsvp.blank?
      current_user.party_reservations.create( party_id: @party.id, email: current_user.email)
      flash[:success] = "Created reservation for #{@party.name}!"
      if @flag
        @party_packages = @party.packages
        # @created_parties = current_user.parties
        respond_to do |format|
          format.js
          format.json { render json: {party_packages: @party_packages} }  # respond with the created JSON object
        end
      else
        redirect_to party_path(@party)
      end
    else
      rsvp.destroy
      flash[:success] = "Deleted reservation for #{@party.name}!"
      redirect_to party_path(@party)
    end
    
    # redirect_to party_path(@party)
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

  def sponsor_request
    PartyMailer.sponsor_request_mailer(params,current_user.email).deliver
    redirect_to party_path(params[:id]), notice: "Your sponsor request submitted successfully"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_party
      @party = Party.find_by_friendly_url(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def party_params
      params.require(:party).permit(:banner, :name, :description, :is_private, :verified, :scheduled_for, :organizer_id, :team_id, :venue_id, :search_item, :search_location,:friendly_url ,:slug , :image_url, :max_rsvp, :business_name, :tags, :invite_type, :sponsor, :sponser_image, :who_created_location, venue_attributes: [:name, :description,  address_attributes: [:street1, :street2, :city, :state, :zip]])
    end

    def sort_parties_geographically(parties)
      @parties_location_distance = Hash.new
      parties.each do |team_party|
        @rvs_party_city = team_party.venue.address.city
        if @parties_location_distance.key?(@rvs_party_city)
          @parties_location_distance[@rvs_party_city]+=1
        else
          @parties_location_distance[@rvs_party_city] = 1
        end
      end

      @user_coor = Geocoder.coordinates(current_user.address.city)

      @parties_location_distance.each do |key,value|
        @party_coor = Geocoder.coordinates(key)
        @parties_location_distance[key] = Address.distance_of_two_locations(@user_coor,@party_coor)
      end

      @sorted_distances = Hash[@parties_location_distance.sort_by{ |k,v| v }]

      @cities_list = @sorted_distances.keys
    end
end
