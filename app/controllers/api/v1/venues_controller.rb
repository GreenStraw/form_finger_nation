module Api
    module V1 
      class VenuesController < ApplicationController
        load_and_authorize_resource :venue
        load_and_authorize_resource :user
        load_and_authorize_resource :party
  
        def index
          venues = Venue.all
          render json: {status: 'SUCCESS', data:venues},status: :ok
        end

        def show
          venue = Venue.find_by_id(params[:id])
          latitude = venue.address.latitude
          longitude = venue.address.longitude
          render json: {status: 'SUCCESS', data:{venue:venue, venue_location: {}}},status: :ok
        end

      end
    end
  end
  