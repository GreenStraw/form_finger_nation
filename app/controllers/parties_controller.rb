class PartiesController < ApplicationController
  before_action :set_party, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :party
  load_and_authorize_resource :package, only: [:purchase_package, :zooz_transaction]

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
  
  end
  
  
  def zooz_postback
    #under development with issues freom Zooz!
    
  end
  
  def zooz_transaction
    @party_package = Package.find(params[:id])
    if params[:cmd]
      #This just tells zooz to initiate the payment process
      post_params = {cmd: "openTrx", amount: @party_package.price, currency_code: "USD"}
      result = Package.zooz_submit(post_params)  
      #result is the session token 
      render :json => {:token => result}
    else
      flash[:notice] = "response from zooz!"
      render :json => {:transaction => result}
      
      #this is the resopnse from zooz and contains the transactionID    
    end
    #redirect_to "/purchase_package/#{@party_package.id.to_s}"
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
