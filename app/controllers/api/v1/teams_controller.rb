module Api
  module V1 
    class TeamsController < ApplicationController
      #load_and_authorize_resource :user
      load_and_authorize_resource :team

      def index
        team = Team.all

        render json: team, status: 201, location: [:api, team]

        #respond_to do |format|
        #  format.json { render :show, status: :created, location: @blog }
          #format.json { render json: @blog.errors, status: :unprocessable_entity }
        #end

        #render json: {status: 'SUCCESS', message:'Loaded articles', data:team},status: :ok

        #respond_to do |format|
          #format.json { render :show, status: :created, location: @blog }
          #format.json { render json: @blog.errors, status: :unprocessable_entity }
        #end
      end

    end
  end
end
