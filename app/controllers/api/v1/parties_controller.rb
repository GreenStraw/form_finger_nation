class Api::V1::PartiesController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy, :rsvp, :unrsvp]
  load_and_authorize_resource :party
  load_and_authorize_resource :package
  load_and_authorize_resource :user

  def index
    respond_with @parties
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

  def create
    @party.save
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
    emails = invite_params[:emails]
    inviter_id = invite_params[:inviter_id]
    party_id = invite_params[:party_id]
    @party = Party.find(invite_params[:party_id])
    PartyInvitation.send_invitations(emails, inviter_id, party_id)

    respond_with @party, :location=>api_v1_teams_path
  end

  private

  def search_parties(lat, lng, radius)
    addresses_in_radius = Address.class_within_radius_of('Venue', lat, lng, radius)
    venues = addresses_in_radius.map(&:addressable)
    venues.map(&:parties).flatten.uniq
  end

  def invite_params
    params.require(:party).permit(:inviter_id, :party_id, { user_ids: [], emails: [] })
  end

  def rsvp_params
    params.permit(:user_id)
  end

  def party_params
    params.require(:party).permit(:name, :description, :is_private, :verified, :scheduled_for, :organizer_id, :venue_id, :team_id, :sport_id, :address, { :attendee_ids=>[], :package_ids=>[] }, address_attributes: [:street1, :street2, :city, :state, :zip])
  end

end
