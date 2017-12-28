module Api
    module V1 
      class VenuesController < ApplicationController
        load_and_authorize_resource :venue
        load_and_authorize_resource :user
        load_and_authorize_resource :party
  
        def index
          venues = Venue.all
        end
        
      end
    end
  end
  