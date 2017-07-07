class VouchersController < ApplicationController
  before_action :set_voucher, only: [:show, :edit, :update, :destroy, :redeem_voucher]
  before_action :set_package, only: [:new, :create]
  before_action :authenticate_user!
  load_and_authorize_resource :user

  load_and_authorize_resource :package
  load_and_authorize_resource :venue
  
  # GET /vouchers
  def index
    @redeemable_vouchers = current_user.vouchers.redeemable
    @history_vouchers = current_user.vouchers.redeemed
  end

  # GET /vouchers/1
  def show
  end

  # GET /vouchers/new
  def new
    @voucher = Voucher.new
  end

  # GET /vouchers/1/edit
  def edit
  end

  # POST /vouchers
  def create
    @voucher = Voucher.new(voucher_params)
    if @voucher.save
      redirect_to @voucher, notice: 'Voucher was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /vouchers/1
  def update
    if @voucher.update(voucher_params)
      redirect_to @voucher, notice: 'Voucher was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /vouchers/1
  def destroy
    @voucher.destroy
    redirect_to vouchers_url, notice: 'Voucher was successfully deleted.'
  end
  
  
  def redeem_voucher
    @voucher.update_attribute(:redeemed_at, Time.now())
    flash[:success] = 'Voucher was successfully redeemed.'
    redirect_to vouchers_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_voucher
      @voucher = Voucher.find(params[:id])
    end

    def set_package
      @package = Package.find(params[:pk_id])
    end

    # Only allow a trusted parameter "white list" through.
    def voucher_params
      params.require(:voucher).permit(:redeemed_at, :user_id, :package_id, :party_id, :pk_id)
    end
end