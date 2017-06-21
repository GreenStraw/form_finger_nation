module VouchersHelper

  def package_selects(venue)
    Package.order(:name).where(for_everyone: false, venue_id: venue).map {|package| [package.name, package.id]}
  end

  def party_selects(venue)
    Party.order(:name).where(venue_id: venue).map {|package| [package.name, package.id]}
  end
end