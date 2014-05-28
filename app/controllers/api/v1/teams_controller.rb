module Api
  module V1
    class TeamsController < BaseController
      before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy]
      respond_to :json

      def index
        return render json: Team.all
      end

      def show
        return render json: Team.find(params[:id])
      end

      def create
        if current_user.has_role?(:admin)
          @team = Team.new(team_params)
          if @team.save
            return render json: @team
          else
            return render json: { :errors => 'Team not created' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def subscribe
        @team = Team.find(params[:team_id])
        update_params = subscribe_params
        update_params[:fans] = fan_id_list_to_fans_for_update(update_params)
        if @team.update!(update_params)
          return render json: @team
        else
          return render json: { :errors => 'Team not updated' }, status: 422
        end
      end

      def update
        @team = Team.find(params[:id])
        if current_user.has_role?(:admin) || current_user == @team.admin
          update_params = team_params
          update_params[:fans] = fan_id_list_to_fans_for_update(update_params)
          if update_params[:sport_id].nil?
            update_params[:sport_id] = @team.sport_id
          end
          if @team.update!(update_params)
            return render json: @team
          else
            return render json: { :errors => 'Team not updated' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def destroy
        if current_user.has_role?(:admin)
          @team = Team.find(params[:id])
          if @team.destroy
            return render json: {}, status:200
          else
            return render json: { :errors => 'Team not deleted' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      private

      def fan_id_list_to_fans_for_update(param_list)
        update_params = param_list
        if update_params[:fans].present?
          user_ids = update_params[:fans]
          fans = []
          if user_ids.any?
            fans = user_ids.map{|sid| User.find_by_id(sid)}.compact.uniq
          end
          fans
        else
          []
        end
      end

      def subscribe_params
        params.permit({:fans => []})
      end

      def team_params
        params[:team][:sport_id] = params[:team][:sport]
        params.require(:team).permit(:name, :image_url, :sport_id, :admin_id, {:fans=>[]})
      end
    end
  end
end
