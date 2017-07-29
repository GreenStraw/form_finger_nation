module VouchersHelper

  def package_selects(venue, package)
    Package.order(:name).where(for_everyone: false, venue_id: venue, id: package).map {|package| [package.name, package.id]}
  end

  def party_selects(current_user)

  	venues =  Venue.where(id: current_user.roles.where("name = 'venue_manager' OR  name = 'manager'").map(&:resource_id))

    pending_parties  = []

    venues.try(:each) do |venue|

      if current_user.admin?
        pending_parties.concat(venue.parties)
      else
        pending_parties.concat(venue.parties.where('parties.organizer_id != ? ', current_user.id).map {|package| [package.name, package.id]} )
      end
    end

    return pending_parties

  end
end