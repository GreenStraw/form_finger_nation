class VouchersController < ApplicationController
  before_action :set_voucher, only: [:show, :edit, :update, :destroy, :redeem_voucher]

  before_action :authenticate_user!
  load_and_authorize_resource :user

  load_and_authorize_resource :package
  load_and_authorize_resource :venue
  
  # GET /vouchers
  def index
    @redeemable_vouchers = Voucher.redeemable(current_user)
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

    #normalize_voucher_params = { :user_id => voucher_params["party_identifier"][1], :party_id => voucher_params["party_identifier"][0], :package_id =>  voucher_params["package_id"]  }

    @voucher = Voucher.new(voucher_params)

    party_organizer_id = Party.where('parties.id = ? ', @voucher[:party_id]).map(&:organizer_id).first

    @voucher.update_attribute(:user_id, party_organizer_id)

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

    voucherRecipient = Voucher.find_by(:user_id  => current_user.id, :party_id => @voucher.party_id, :package_id => @voucher.package_id)


    if !voucherRecipient.present?
      voucherRecipient.assign_attributes(:redeemed_at, Time.now())
      voucherRecipient.save!
    else
      @voucher.update_attribute(:redeemed_at, Time.now())
    end

    flash[:success] = 'Voucher was successfully redeemed.'
    redirect_to vouchers_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_voucher
      @voucher = Voucher.find(params[:id])
    end



    # Only allow a trusted parameter "white list" through.
    def voucher_params
      params.require(:voucher).permit(:redeemed_at, :user_id, :package_id, :party_id)
    end
end