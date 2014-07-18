class Api::V1::AddressesController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!, except: [:create]
  load_and_authorize_resource

  def index
    respond_with @addresses
  end

  def show
    respond_with @address
  end

  def create
    @address.save
    respond_with @address, :location=>api_v1_addresses_path
  end

  def update
    @address.update(address_params)
    respond_with @address, :location=>api_v1_addresses_path
  end

  private

  def address_params
    params.require(:address).permit(:street1, :street2, :city, :state, :zip, :addressable_id, :addressable_type)
  end

end
