class PackagesController < ApplicationController
  before_action :set_package, only: [:show, :edit, :update, :destroy]
  respond_to :html, :js
  load_and_authorize_resource :package
  load_and_authorize_resource :venue
  load_and_authorize_resource :party

  # GET /packages
  def index
    respond_with @packages
  end

  # GET /packages/1
  def show
  end

  # GET /packages/new
  def new
    respond_with @package

end
  # GET /packages/1/edit
  def edit
  end

  # POST /packages
  def create
    flash[:notice] = 'Package was successfully created.' if @package.save
    respond_with @package, location: edit_venue_path(@package.venue)
  end

  # PATCH/PUT /packages/1
  def update
    flash[:notice] = 'Package was successfully updated.' if @package.update(package_params)
    respond_with @package, location: package_path(@package)
  end

  # DELETE /packages/1
  def destroy
    @package.destroy
    redirect_to packages_url, notice: 'Package was successfully destroyed.'
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

    # Only allow a trusted parameter "white list" through.
    def package_params
      params.require(:package).permit(:name, :description, :image_url, :price, :active, :is_public, :start_date, :end_date, :venue_id, :references)
    end
end
