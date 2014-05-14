module Api
  module V1
    class WatchPartiesController < BaseController
      before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy]
      respond_to :json

      def index
        return render json: WatchParty.all
      end

      def show
        return render json: WatchParty.find(params[:id])
      end

      def create
        @watch_party = WatchParty.new(update_params)
        if @watch_party.save
          current_user.add_role(:manager, @watch_party)
          return render json: @watch_party
        else
          return render json: { :errors => 'Watch Party not created' }, status: 422
        end
      end

      def update
        @watch_party = WatchParty.find(params[:id])
        if current_user.has_role?(:admin) || current_user.has_role?(:manager, @watch_party)
          if @watch_party.update!(update_params)
            return render json: @watch_party
          else
            return render json: { :errors => 'Watch Party not updated' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def destroy
        @watch_party = WatchParty.find(params[:id])
        if current_user.has_role?(:admin) || current_user.has_role?(:manager, @watch_party)
          if @watch_party.destroy
            return render json: {}, status:200
          else
            return render json: { :errors => 'Watch Party not deleted' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      private

      def build_scheduled_time(date, time)
        d = date.to_date
        split_time = time.split(':')
        hour = split_time[0].to_i
        split_2 = split_time[1].split(' ')
        minute = split_2[0].to_i
        am_pm = split_2[1]
        if am_pm.downcase == 'pm' && hour != 12
          hour += 12
        elsif am_pm.downcase == 'am' && hour == 12
          hour = 0
        end
        DateTime.new(d.year, d.month, d.day, hour, minute, 0, 0)
      end

      def update_params
        if params[:watchParty].present? && params[:watch_party].empty?
          params[:watch_party] = params[:watchParty]
        end
        params[:watch_party][:organizer_id] = params[:watch_party][:organizer]
        params[:watch_party][:team_id] = params[:watch_party][:team]
        params[:watch_party][:sport_id] = params[:watch_party][:sport]
        params[:watch_party][:establishment_id] = params[:watch_party][:establishment]
        params[:watch_party][:scheduled_for] = build_scheduled_time(params[:watch_party][:scheduled_date], params[:watch_party][:scheduled_time])
        params.require(:watch_party).permit(:name, :description, :private, :scheduled_for, :organizer_id, :establishment_id, :team_id, :sport_id)#, { :attendees=>[] })
      end

      def watch_party_params
        params.require(:watch_party).permit(:name, :description, :private, :scheduled_for, :organizer_id, :establishment_id, :team_id, :sport_id)#, { :attendees=>[] })
      end
    end
  end
end
