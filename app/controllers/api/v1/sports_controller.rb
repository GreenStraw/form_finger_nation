module Api
    module V1 
      class SportsController < ApplicationController
        load_and_authorize_resource :sport
  
        def index
          sports = Sport.all
          render json: {status: 'SUCCESS', data: sports},status: :ok
        end

      end
    end
  end
  