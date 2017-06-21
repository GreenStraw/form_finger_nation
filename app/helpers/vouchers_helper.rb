module VouchersHelper

  def package_selects
    Package.order(:name).where(for_everyone: false, venue_id: Venue.id).map {|package| [package.name, package.id]}
  end

  def party_selects
    Party.order(:name).map {|package| [package.name, package.id]}
  end
end