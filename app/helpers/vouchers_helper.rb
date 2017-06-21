module VouchersHelper

  def package_selects(test)
    Package.order(:name).where(for_everyone: false).map {|package| [package.name, package.id]}
  end

  def party_selects
    Party.order(:name).map {|package| [package.name, package.id]}
  end
end