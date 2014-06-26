class Api::V1::VouchersController < Api::V1::BaseController
  load_and_authorize_resource

  def show
    respond_with @voucher
  end

  def create
    @voucher.save
    respond_with @voucher, :location=>api_v1_vouchers_path
  end

  def redeem
    if @voucher.redeemed?
      @voucher.errors.add(:redeemed, 'has already been redeemed')
    else
      @voucher.update_attribute(:redeemed, true)
    end
    respond_with @voucher, :location=>api_v1_vouchers_path
  end

  private

  def voucher_params
    params.require(:voucher).permit(:user_id, :package_id)
  end

end
