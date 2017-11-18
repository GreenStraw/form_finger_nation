module Api
  module V1 
    class TeamsController < ApplicationController
      #load_and_authorize_resource :user
      load_and_authorize_resource :team

      def index
        team = Team.all
        render json: {status: 'SUCCESS', message:'Loaded articles', data:team},status: :ok
      end

    end
  end
end
