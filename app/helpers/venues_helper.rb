module VenuesHelper
  def venue_selects 
    Venue.order(:name).map {|venue| [venue.name, "#{venue.name} (#{venue.address.street1} #{venue.address.city}, #{venue.address.state})"]}
  end
end