module VouchersHelper

  def package_selects(venue, package)
    Package.order(:name).where(for_everyone: false, venue_id: venue, id: package).map(&:id).first
  end

  def party_selects(current_user)

  	venues =  Venue.where(id: current_user.roles.where("name = 'venue_manager' OR  name = 'manager'").map(&:resource_id))

    venue_assigned_parties  = []

    venues.try(:each) do |venue|

      if current_user.admin?
        venue_assigned_parties.concat(venue.parties.map {|party| [party.name, party.id]})
      else
        # venue_assigned_parties.concat(venue.parties.where('parties.organizer_id != ? ', current_user.id).map {|party| [party.name, party.id ]} )
      	venue_assigned_parties.concat(venue.parties.map {|party| [party.name, party.id ]} )
      end
    end

    return venue_assigned_parties

  end
end