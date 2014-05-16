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

      def update
        if current_user.has_role?(:admin)
          @team = Team.find(params[:id])
          update_params = team_params
          update_params[:users] = user_id_list_to_users_for_update
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

      def user_id_list_to_users_for_update
        update_params = team_params
        if update_params[:users].present?
          user_ids = update_params[:users]
          users = []
          if user_ids.any?
            users = user_ids.map{|sid| User.find_by_id(sid)}.compact.uniq
          end
          users
        else
          []
        end
      end

      def team_params
        params[:team][:sport_id] = params[:team][:sport]
        params.require(:team).permit(:name, :image_url, :sport_id, {:users=>[]})
      end
    end
  end
end
