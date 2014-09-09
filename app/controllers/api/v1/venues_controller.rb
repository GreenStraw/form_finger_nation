class Api::V1::VenuesController < Api::V1::BaseController
  load_and_authorize_resource :user
  load_and_authorize_resource :venue

  def index
    respond_with @venues.includes(:followed_teams, :followed_sports, :parties, :packages)
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

  def add_manager
    @user.add_role(:manager, @venue)
    respond_with @venue, :location=>api_v1_venues_path
  end

  def remove_manager
    @user.remove_role(:manager, @venue)
    respond_with @venue, :location=>api_v1_venues_path
  end

  def packages
    respond_with @venue.packages, each_serializer: PackageSerializer, root: 'packages'
  end

  private

  def venue_params
    params.require(:venue).permit(:name, :image_url, :description, :address, :phone, :email, :hours_monday, :hours_tuesday, :hours_wednesday, :hours_thursday, :hours_friday, :hours_saturday, :hours_sunday, {:favorite_team_ids=>[], :favorite_sport_ids=>[], :party_ids=>[], :package_ids=>[]}, address_attributes: [:street1, :street2, :city, :state, :zip])
  end

end
