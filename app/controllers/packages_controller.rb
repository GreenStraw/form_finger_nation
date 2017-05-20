class PackagesController < ApplicationController
  before_action :set_package, only: [:show, :edit, :update, :destroy]
  before_action :set_party, only: [:assign, :unassign]
  respond_to :html, :js
  load_and_authorize_resource :package
  load_and_authorize_resource :venue
  load_and_authorize_resource :party

  # GET /packages
  def index
    #respond_with @packages.includes(:parties, :vouchers, :venue)
  end

  # GET /packages/1
  def show
    if params[:party_package]
      @party_package = params[:party_package]
    end
  end

  # GET /packages/new
  def new
    if params[:party_id].present?
      @party = Party.find(params[:party_id])
      @flag = true
    end
    @package.venue = @venue
    respond_with @package
  end
  
  
  # GET /packages/1/edit
  def edit
  end

  # POST /packages
  def create
    if @package.save
      if params[:commit] == 'Create'
        @party = Party.find(params[:party_id])
        temp = PartyPackage.create
        temp.party_id = params[:party_id]
        temp.package_id = @package.id
        temp.save
        redirect_to parties_path(@party), notice: 'Package was successfully created.'
      else
        flash[:notice] = 'Package was successfully created.'
        respond_with @package, location: edit_venue_path(@package.venue)
      end
    end 
  end

  # PATCH/PUT /packages/1
  def update
    flash[:notice] = 'Package was successfully updated.' if @package.update(package_params)
    respond_with @package, location: package_path(@package)
  end

  # DELETE /packages/1
  def destroy
    venue = @package.venue
    @package.destroy
    redirect_to edit_venue_path(venue), notice: 'Package was successfully deleted.'
  end

  def assign
    if !@package.parties.include?(@party)
      @package.parties << @party
    end
    respond_with @package
  end

  def unassign
    if @package.parties.include?(@party)
      @package.parties.delete(@party)
    end
    respond_with @package
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package
      @package = Package.find(params[:id])
    end

    def set_party
      @party = Party.find_by_friendly_url(params[:party_id])
    end

    # Only allow a trusted parameter "white list" through.
    def package_params
      params.require(:package).permit(:name, :description, :image_url, :price, :active, :is_public, :start_date, :end_date, :venue_id, :references)
    end
end
