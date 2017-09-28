class Api::V1::PartiesController < Api::V1::BaseController
  before_action :authenticate_user_from_token!, only: [:create, :update, :destroy, :rsvp, :unrsvp]
  load_and_authorize_resource :party
  load_and_authorize_resource :package
  load_and_authorize_resource :user

  def index
    respond_with @parties.includes(:party_invitations, :attendees, :packages, :vouchers, :organizer, :team, :sport, :venue)
  end

  def show
    respond_with @party
  end

  def by_attendee
    respond_with Party.joins(:attendees).merge(User.where(id: @user.id))
  end

  def by_organizer
    respond_with Party.where(organizer_id: @user.id)
  end

  def by_user_favorites
    respond_with Party.where(team_id: @user.followed_team_ids)
  end

  def create
    @party.save
    current_user.party_reservations.create(party_id: @party.id, email: current_user.email)
    respond_with @party, :location=>api_v1_parties_path
  end

  def update
    @party.update(party_params)
    respond_with @party, :location=>api_v1_parties_path
  end

  def destroy
    @party.destroy
    respond_with @party, :location=>api_v1_parties_path
  end

  def add_package
    if !@party.packages.include?(@package)
      @party.packages << @package
    end
    respond_with @party
  end

  def remove_package
    if @party.packages.include?(@package)
      @party.packages.delete(@package)
    end
    respond_with @party
  end

  def search
    radius = params[:radius] || 25
    lat = params[:lat]
    lng = params[:lng]
    parties = search_parties(lat, lng, radius)
    respond_with parties
  end

  def rsvp
    @party = Party.find(params[:id])
    @user = User.find(rsvp_params[:user_id])
    if !@party.attendees.include?(@user)
      @party.attendees << @user
    end
    respond_with @party, :location=>api_v1_teams_path
  end

  def unrsvp
    @party = Party.find(params[:id])
    @user = User.find(rsvp_params[:user_id])
    if @party.attendees.include?(current_user)
      @party.attendees.delete(current_user)
    end
    respond_with @party, :location=>api_v1_teams_path
  end

  def invite
    emails = params[:emails]
    PartyInvitation.send_invitations(emails, @party.organizer_id, @party.id)
    respond_with @party, :location=>api_v1_teams_path
  end

  private

  def search_parties(lat, lng, radius)
    addresses_in_radius = Address.class_within_radius_of('Venue', lat, lng, radius)
    venues = addresses_in_radius.map(&:addressable).compact
    venues.map(&:upcoming_parties).flatten.uniq
  end

  def rsvp_params
    params.permit(:user_id)
  end

  def party_params
    params.require(:party).permit(:name, :description, :is_private, :verified, :scheduled_for, :organizer_id, :venue_id, :team_id, :sport_id, :address, { :attendee_ids=>[], :package_ids=>[] }, address_attributes: [:street1, :street2, :city, :state, :zip])
  end

end
