class Api::V1::VenuesController < Api::V1::BaseController
  load_and_authorize_resource
  
  def index
    respond_with @venues
  end

  def show
    respond_with @venue
  end

  def create
    @venue.save
    respond_with @venue, :location=>api_v1_venues_path
  end

  def update
    @venue.update(venue_params)
    respond_with @venue, :location=>api_v1_venues_path
  end

  def destroy
    @venue.destroy
    respond_with @venue, :location=>api_v1_venues_path
  end

  private

  def venue_params
    params.require(:venue).permit(:name, :image_url, :description, :address, {:favorite_team_ids=>[], :favorite_sport_ids=>[], :party_ids=>[], :package_ids=>[]})
  end

end
