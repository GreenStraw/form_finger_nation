module Api
    module V1 
      class PartiesController < ApplicationController

        load_and_authorize_resource :venue
        load_and_authorize_resource :user
        load_and_authorize_resource :party
        load_and_authorize_resource :party_package
  
        def index
          parties = Party.all
          render json: {status: 'SUCCESS', data:parties},status: :ok
        end

        def show
          party = Party.find_by_id(params[:id])
          party_packages = Party.getPartyPackages(party.venue.id, party.id)

          render json: {status: 'SUCCESS', data:{party:party, party_packages: party_packages}},status: :ok
        end

      end
    end
  end
  