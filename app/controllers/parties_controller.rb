class PartiesController < ApplicationController
  before_action :set_party, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :party
  load_and_authorize_resource :party_package, only: [:purchase_package]

  # GET /parties
  def index
    @user = current_user   
  end

  # GET /parties/1
  def show
  end

  # GET /parties/new
  def new
  end

  # GET /parties/1/edit
  def edit
  end

  # POST /parties
  def create
    @party = Party.new(party_params)

    if @party.save
      redirect_to @party, notice: 'Party was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /parties/1
  def update
    if @party.update(party_params)
      redirect_to @party, notice: 'Party was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /parties/1
  def destroy
    @party.destroy
    redirect_to parties_url, notice: 'Party was successfully destroyed.'
  end
  
  def purchase_package

    @party_package = PartyPackage.find(params[:party_package_id]) unless params[:party_package_id].blank?
  
  end
  
  
  def zooz_postback
    #under development with issues from Zooz!
    
  end
  

  def zooz_transaction
    if params[:cmd]
      @party_package = PartyPackage.find(params[:party_package_id])
      #This just tells zooz to initiate the payment process
      post_params = {cmd: "openTrx", amount: @party_package.package.price, currency_code: "USD"}
      result = Package.zooz_submit(post_params)  
      #result is the session token 
      render :json => {:token => result}
    else
      if params[:statusCode] == "0"
        party_package = PartyPackage.where(id: params[:party_package_id]).first
        @party = party_package.party
        @package = party_package.package
        @voucher = Voucher.create(transaction_display_id: params[:transactionDisplayID], transaction_id: params[:trxId], user_id: current_user.id, package_id: @package.id,  party_id: @party.id)
        flash[:notice] = "You have purchased #{@package.name}, Your transaction is #{params[:transactionDisplayID]}"
      else
        flash[:error] = "Error processing the credit card"
      end
      redirect_to "/purchase_package/#{party_package.id.to_s}"
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_party
      @party = Party.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def party_params
      params.require(:party).permit(:name, :description, :is_private, :verified, :scheduled_for, :organizer_id, :team_id, :venue_id, :search_item)
    end
    
    
end
