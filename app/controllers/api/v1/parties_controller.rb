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

      end
    end
  end
  