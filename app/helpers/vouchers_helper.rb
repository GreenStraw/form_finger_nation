module VouchersHelper

  def package_selects(venue)
    Package.order(:name).where(for_everyone: false, venue_id: venue).map {|package| [package.name, package.id]}
  end

  def party_selects
    Party.order(:name).map {|package| [package.name, package.id]}
  end
end