module VouchersHelper
  def package_selects
    Package.order(:name).map {|package| [package.name, package.id]}
  end
end