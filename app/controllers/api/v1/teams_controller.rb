module Api
  module v1 
    class TeamsController < Api::v1::BaseController
      load_and_authorize_resource :user
      load_and_authorize_resource :team
      before_action :authenticate_user_from_token!, only: [:create, :update, :destroy, :add_host, :remove_host]

      def index
        if params[:date].present? && params[:date].is_a?(String) && params[:date].to_i.is_a?(Integer)
          date = params[:date]
          respond_with @teams.includes(:address, :fans, :venue_fans, :hosts, :endorsement_requests, :sport).select{|t| t.updated_at.to_i > date.to_i}
        else
          respond_with @teams.includes(:address, :fans, :venue_fans, :hosts, :endorsement_requests, :sport)
        end
      end

      def show
        respond_with @team
      end

      def create
        @team.save
        respond_with @team, :location=>api_v1_teams_path
      end

      def update
        @team.update(team_params)
        respond_with @team, :location=>api_v1_teams_path
      end

      def destroy
        @team.destroy
        respond_with @team, :location=>api_v1_teams_path
      end

      def add_host
        if !@team.hosts.include?(@user)
          @team.hosts << @user
        end
        respond_with @team, :location=>api_v1_teams_path
      end

      def remove_host
        if @team.hosts.include?(@user)
          @team.hosts.delete(@user)
        end
        respond_with @team, :location=>api_v1_teams_path
      end

      def add_admin
        @user.add_role(:team_admin, @team)
        respond_with @team, :location=>api_v1_teams_path
      end

      def remove_admin
        @user.remove_role(:team_admin, @team)
        respond_with @team, :location=>api_v1_teams_path
      end

      def subscribe_user
        if !@team.fans.include?(@user)
          @team.fans << @user
        end
        respond_with @team
      end

      def unsubscribe_user
        if @team.fans.include?(@user)
          @team.fans.delete(@user)
        end
        respond_with @team
      end

      private

      def subscribe_params
        params.permit(:fan_id)
      end

      def team_params
        params.require(:team).permit(:name, :information, :image_url, :sport_id, :address, {:fan_ids=>[], :host_ids=>[]}, address_attributes: [:street1, :street2, :city, :state, :zip])
      end

    end
  end
end
