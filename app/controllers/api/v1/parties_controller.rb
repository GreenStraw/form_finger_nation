class Api::V1::PartiesController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy, :rsvp, :unrsvp]

  def index
    search = params[:query] if params[:query]
    address = params[:address] if params[:address]
    radius = params[:radius] if params[:radius]
    from_date = params[:fromDate].to_date if params[:fromDate]
    to_date = params[:toDate].to_date if params[:toDate]
    results = if address.present?
      search_parties(search, address, radius, from_date, to_date)
    else
      Party.all
    end
    return render json: results
  end

  def show
    return render json: Party.find(params[:id])
  end

  def create
    @party = Party.new(party_params)
    if @party.save
      current_user.add_role(:manager, @party)
      return render json: @party
    else
      return render json: { :errors => @party.errors.full_messages }, status: 422
    end
  end

  def update
    @party = Party.find(params[:id])
    if current_user.has_role?(:admin) || current_user.has_role?(:manager, @party)
      if @party.update!(update_params)
        return render json: @party
      else
        return render json: { :errors => @party.errors.full_messages }, status: 422
      end
    else
      return render json: {}, status: 403
    end
  end

  def destroy
    @party = Party.find(params[:id])
    if current_user.has_role?(:admin) || current_user.has_role?(:manager, @party)
      if @party.destroy
        return render json: {}, status:200
      else
        return render json: { :errors => @party.errors.full_messages }, status: 422
      end
    else
      return render json: {}, status: 403
    end
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

  private

  def search_parties(search, address, radius, from_date, to_date)
    bar_ids = venue_ids_by_address_and_radius(address, radius)
    parties_by_date = Party.where(scheduled_for: from_date.beginning_of_day..to_date.end_of_day, private: false)
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

  def build_scheduled_time(date, time)
    d = date.to_date
    split_time = time.split(':')
    hour = split_time[0].to_i
    split_2 = split_time[1].split(' ')
    minute = split_2[0].to_i
    am_pm = split_2[1]
    if am_pm.downcase == 'pm' && hour != 12
      hour += 12
    elsif am_pm.downcase == 'am' && hour == 12
      hour = 0
    end
    DateTime.new(d.year, d.month, d.day, hour, minute, 0, 0)
  end

  def update_params
    params[:party][:scheduled_for] = build_scheduled_time(params[:party][:scheduled_date], params[:party][:scheduled_time])
    params.require(:party).permit(:name, :description, :private, :scheduled_for, :organizer_id, :venue_id, :team_id, :sport_id, :address, { :attendee_ids=>[] })
  end

  def rsvp_params
    params.permit(:user_id)
  end

  def party_params
    params.require(:party).permit(:name, :description, :private, :verified, :scheduled_for, :organizer_id, :venue_id, :team_id, :sport_id, :address, { :attendee_ids=>[], :package_ids=>[] })
  end

end
