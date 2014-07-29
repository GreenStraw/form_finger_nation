class Api::V1::VouchersController < Api::V1::BaseController
  load_and_authorize_resource :party
  load_and_authorize_resource :user
  load_and_authorize_resource

  def index
    respond_with @vouchers
  end

  def show
    respond_with @voucher
  end

  def update
    @voucher.update(voucher_params)
    respond_with @voucher, :location=>api_v1_packages_path
  end

  def create
    @voucher.save
    respond_with @voucher, :location=>api_v1_vouchers_path
  end

  def redeem
    if @voucher.redeemed_at.present?
      @voucher.errors.add(:base, 'has already been redeemed')
    else
      verification_response, verification_errors = @voucher.verify
      if verification_response
        @voucher.update_attribute(:redeemed_at, DateTime.now)
      else
        @voucher.errors.add(:base, verification_errors)
      end
    end
    respond_with @voucher, :location=>api_v1_vouchers_path
  end

  def by_user
    respond_with Voucher.joins(:user).merge(User.where(id: @user.id))
  end

  private

  def voucher_params
    params.require(:voucher).permit(:user_id, :package_id, :party_id, :transaction_display_id, :transaction_id)
  end

end
