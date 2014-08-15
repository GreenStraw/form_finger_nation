class PartiesController < ApplicationController
  before_action :set_party, only: [:show, :edit, :update, :destroy]

  # GET /parties
  def index
    radius = 50 #set the location search radius
    #search scenarios, we can either have a search_item, search_location, or both
    party_params = params[:party]
    if party_params.blank? || (party_params[:search_item].blank? && party_params[:search_location].blank?)
      @parties, @teams, @people = Party.search("")
    else
      if party_params[:search_item].blank? && !party_params[:search_location].blank?
        #location search only
        @parties = Party.geo_search(party_params[:search_location], radius)
        @teams = []
        @people = []
      elsif !party_params[:search_item].blank? && party_params[:search_location].blank?
        #search item search only
        @parties, @teams, @people = Party.search(party_params[:search_item])
      else
        #both search
        parties1  = Party.geo_search(party_params[:search_location], radius)
        parties2, @teams, @people = Party.search(party_params[:search_item])
        @parties = (parties1 & parties2)
        @teams = []
        @people = []
      end
    end
  end

  # GET /parties/1
  def show
  end

  # GET /parties/new
  def new
    @party = Party.new
    init_selects    
  end

  # GET /parties/1/edit
  def edit
    @party = Party.find(params[:id])
    init_selects
  end

  # POST /parties
  def create
    @party = Party.new(party_params)

    if @party.save
      redirect_to @party, notice: 'Party was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /parties/1
  def update
    if @party.update(party_params)
      redirect_to @party, notice: 'Party was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /parties/1
  def destroy
    @party.destroy
    redirect_to parties_url, notice: 'Party was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_party
      @party = Party.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def party_params
      params.require(:party).permit(:name, :description, :is_private, :verified, :scheduled_for, :organizer_id, :team_id, :venue_id, :search_item)
    end
    
    def init_selects
      @team_selects = Team.order(:name).map {|team| [team.name, team.id]}
      @venue_selects = Venue.order(:name).map {|venue| [venue.name, venue.id]}
    end
end
