class Api::V1::PartiesController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy, :rsvp, :unrsvp]
  load_and_authorize_resource

  def index
    respond_with @parties=Party.all
  end

  def show
    respond_with @party
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

  def search
    search = params[:query] if params[:query]
    address = params[:address] if params[:address]
    radius = params[:radius] if params[:radius]
    from_date = params[:fromDate].to_date if params[:fromDate]
    to_date = params[:toDate].to_date if params[:toDate]
    @results = search_parties(search, address, radius, from_date, to_date)
    render json: @results, status: 200
  end

  def rsvp
    @party = Party.find(params[:id])
    @user = User.find(rsvp_params[:user_id])
    if current_user == @user
      if !@party.attendees.include?(current_user)
        @party.attendees << current_user
      end
      return render json: @party
    else
      return render json: {}, status: 403
    end
  end

  def unrsvp
    @party = Party.find(params[:id])
    @user = User.find(rsvp_params[:user_id])
    if current_user == @user
      if @party.attendees.include?(current_user)
        @party.attendees.delete(current_user)
      end
      return render json: @party
    else
      return render json: {}, status: 403
    end
  end

  def invite
    emails = invite_params[:emails]
    inviter_id = invite_params[:inviter_id]
    party_id = invite_params[:party_id]
    party = Party.find(invite_params[:party_id])
    if current_user.id == inviter_id && current_user.id == party.organizer_id
      invitations = PartyInvitation.send_invitations(emails, inviter_id, party_id)
      return render json: party, status: 201
    else
      return render json: {}, status: 403
    end
  end

  private

  def search_parties(search, address, radius, from_date, to_date)
    bar_ids = venue_ids_by_address_and_radius(address, radius)
    parties_by_date = Party.where(scheduled_for: from_date.beginning_of_day..to_date.end_of_day, is_private: false)
    parties_in_area = parties_by_date.where(venue_id: bar_ids)
    results = parties_in_area.where("name ilike '%#{search}%'")
    teams = Team.where("name ilike '%#{search}%'")
    if teams.any?
      results += parties_in_area.where("team_id in (#{teams.map(&:id).join(',')})")
    end
    venues = Venue.where("name ilike '%#{search}%'")
    if venues.any?
      results += parties_in_area.where("venue_id in (#{venues.map(&:id).join(',')})")
    end
    results.to_a.compact.uniq
  end

  def venue_ids_by_address_and_radius(address, radius)
    results = []
    add = address
    rad = radius || 10
    addresses = Address.near(add, rad).to_a
    if addresses.any?
      venue_ids = addresses.select{|a| a.addressable_type=='Venue'}.to_a.map(&:addressable_id)
      results = Venue.where(:id => venue_ids).to_a.map(&:id)
    end
    results || []
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
