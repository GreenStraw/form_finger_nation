class Api::V1::PackagesController < Api::V1::BaseController
  before_action :authenticate_user_from_token!, only: [:create, :update, :destroy]
  load_and_authorize_resource

  def index
    respond_with @packages
  end

  def show
    respond_with @package
  end

  def create
    @package.save
    respond_with @package, :location=>api_v1_packages_path
  end

  def update
    @package.update(package_params)
    respond_with @package, :location=>api_v1_packages_path
  end

  def destroy
    @package.destroy
    respond_with @package, :location=>api_v1_packages_path
  end

  private

  def package_params
    params.require(:package).permit(:name, :description, :image_url, :price, :active, :start_date, :end_date, :venue_id, {:party_ids=>[]})
  end

end
