module Api
  module V1 
    class TeamsController < ApplicationController
      load_and_authorize_resource :user
      load_and_authorize_resource :team
      load_and_authorize_resource :sport

      def index
        teams = Team.all
        #render json: team, status: 201, location: [:api, team]

        #respond_to do |format|
        #  format.json { render :show, status: :created, location: @blog }
          #format.json { render json: @blog.errors, status: :unprocessable_entity }
        #end

        render json: {status: 'SUCCESS', data:teams},status: :ok

        #respond_to do |format|
          #format.json { render :show, status: :created, location: @blog }
          #format.json { render json: @blog.errors, status: :unprocessable_entity }
        #end
      end

      def show
        team = Team.find_by_id(params[:id])
        render json: {status: 'SUCCESS', data:{team:team } },status: :ok
      end

      def favorite_teams
        current_user = User.find_by_id("481")

        #has_favorites = user_signed_in? && current_user.followed_teams.any?
        has_favorites = current_user.followed_teams.any?

        if has_favorites
          teams = current_user.followed_teams
          render json: {status: 'SUCCESS', data:teams},status: :ok
        #else
        #    redirect_to teams_path
        end
      end

      def get_teams_by_sport
        sportId = params[:sportId]

        sport = Sport.find_by_id(params[:sportId])
        
        if sport.present? && sport.teams.any?
          #teams_by_sport = Team.teams_by_sport(sportId)
          teams_by_sport = sport.teams
          render json: {status: 'SUCCESS', data: teams_by_sport },status: :ok
        end
      end

    end
  end
end
