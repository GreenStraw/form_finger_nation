class TeamsController < ApplicationController
  respond_to :html, :js
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :team, :except=>[:search, :homesearch]
  load_and_authorize_resource :user
  load_and_authorize_resource :sport
  skip_before_filter  :verify_authenticity_token
  # GET /teams
  def index
    @has_favorites = user_signed_in? && current_user.followed_teams.any?
    @teams_by_sport = Team.ordered_teams(Team.all)
    respond_with @teams_by_sport
  end

  def search
    if params[:keyword] == ''
      @has_favorites = user_signed_in? && current_user.followed_teams.any?
      @teams_by_sport = Team.ordered_teams(Team.all)
    else  
      key = "%#{params[:keyword]}%"
      key = key.downcase

      @has_favorites = user_signed_in? && current_user.followed_teams.where("teams.name ilike ? ", key).any?
      @teams_by_sport = Team.where("teams.name ilike ? ", key).group_by{|t| t.sport.name}
      # sport_names_with_teams = Sport.ordered_sports
      # ordered_teams = {}
      # sport_names_with_teams.each do |sport_name, teams|
      #   ordered_teams[sport_name] = teams
      # end

      # puts "-"*80
      # puts @teams_by_sport
      # puts key
      # puts "-"*80
    end
    respond_to do |format|
      format.js
      format.json { render json: {created_parties: @teams_by_sport} }  # respond with the created JSON object
    end
  end

  def homesearch
    keyword = params[:key]
    keyword = keyword.gsub('%20', ' ')
    team = Team.find_by_name(keyword)
    if team
      redirect_to team_path(team);
    else
      redirect_to cant_find_teams_path
    end
  end

  def parties_in_area

    lat = nil
    lon = nil
    overrideAddress = params[:overrideAddress]

    @teams_in_area = []
    @teams_out_area = []
    
    if overrideAddress.nil?

      #return render json: {}, status: 409

        respond_to do |format|
          format.js
          format.json { render json: {parties_near_me: @teams_in_area } }  # respond with the created JSON object
        end

    elsif overrideAddress.to_s == 'true'

        lat = current_user.address.latitude   #||  request.location.latitude
        lon = current_user.address.longitude  #||  request.location.longitude

    else

        lat = request.location.latitude
        lon = request.location.longitude

    end

    if !lat.nil? && !lon.nil?
      @teams_in_area, @teams_out_area = Team.geo_search(lat, lon, 50, @team.id)
    end

    respond_to do |format|
      format.js
      format.json { render json: {parties_near_me: @teams_in_area, parties_away: @teams_out_area} }  # respond with the created JSON object
    end
  
  end

  # GET /teams/1
  def show
    
    @map_markers = Gmaps4rails.build_markers(@team) do |team, marker|
      marker.lat team.address.latitude
      marker.lng team.address.longitude
    end
    respond_with @team
  end

  # GET /teams/new
  def new
    @team.sport = @sport
    respond_with @team
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  def create
    flash[:notice] = 'Team was successfully created.' if @team.save
    respond_with @team, location: team_path(@team)
  end

  # PATCH/PUT /teams/1
  def update
    flash[:notice] = 'Team was successfully updated.' if @team.update(team_params)
    respond_with @team, location: team_path(@team)
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'Team was successfully deleted.'
  end

  def subscribe
    @user = current_user
    if !@team.fans.include?(current_user)
      x = Favorite.new
      x.favoritable_id = @team.id
      x.favoritable_type = "Team"
      x.favoriter_id = @user.id
      x.favoriter_type = "User"
      x.save!
    
    else
      return render json: {}, status: 409
    end
    @favorites = current_user.followed_teams || []
    flash.now[:notice] = "#{@team.name} added to favorites"
    respond_to do |format|
      format.js { render json: {}, status: 200 }
    end
  end

  def unsubscribe
    if @team.fans.include?(current_user)
      @user = current_user
      x = Favorite.find_by(:favoritable_id  => @team.id, :favoritable_type => "Team", :favoriter_id => @user.id, :favoriter_type => "User")
      x.delete if x.present?
      # @team.fans.delete(current_user)
    else
      return render json: {}, status: 409
    end
    flash.now[:notice] = "#{@team.name} removed from favorites"
    respond_to do |format|
      format.js { render json: {}, status: 200 }
    end
  end

  def add_host
    if !@team.hosts.include?(@user)
      @team.hosts << @user
    end
    respond_to do |format|
      format.js { render action: 'host' }
    end
  end

  def remove_host
    if @team.hosts.include?(@user)
      @team.hosts.delete(@user)
    end
    respond_to do |format|
      format.js { render action: 'host' }
    end
  end

  def add_admin
    if !@user.has_role?(:team_admin, @team)
      @user.add_role(:team_admin, @team)
    end
    respond_to do |format|
      format.js { render action: 'admin' }
    end
  end

  def remove_admin
    if @user.has_role?(:team_admin, @team)
      @user.remove_role(:team_admin, @team)
    end
    respond_to do |format|
      format.js { render action: 'admin' }
    end
  end

  def favorite_teams

    @has_favorites = user_signed_in? && current_user.followed_teams.any?
    
    if @has_favorites
      @teams = current_user.followed_teams
    else
       redirect_to teams_path
    end

  end

  def cant_find
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find_by_page_name(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def team_params
    params.require(:team).permit(:page_name, :banner,:name, :information, :text, :image_url, :sport_id, :references, :twitter_name, :twitter_widget_id, :address, [address_attributes: [:street1, :street2, :city, :state, :zip]])
  end
end
