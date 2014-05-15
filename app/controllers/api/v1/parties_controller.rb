module Api
  module V1
    class PartiesController < BaseController
      before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy]
      respond_to :json

      def index
        return render json: Party.all
      end

      def show
        return render json: Party.find(params[:id])
      end

      def create
        @party = Party.new(update_params)
        if @party.save
          current_user.add_role(:manager, @party)
          return render json: @party
        else
          return render json: { :errors => 'Watch Party not created' }, status: 422
        end
      end

      def update
        @party = Party.find(params[:id])
        if current_user.has_role?(:admin) || current_user.has_role?(:manager, @party)
          if @party.update!(update_params)
            return render json: @party
          else
            return render json: { :errors => 'Watch Party not updated' }, status: 422
          end
        else
          return render json: {}, status: 403
        end
      end

      def destroy
        @party = Party.find(params[:id])
        if current_user.has_role?(:admin) || current_user.has_role?(:manager, @party)
          if @party.destroy
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
        # if params[:watchParty].present? && params[:party].empty?
        #   params[:party] = params[:watchParty]
        # end
        params[:party][:organizer_id] = params[:party][:organizer]
        params[:party][:team_id] = params[:party][:team]
        params[:party][:sport_id] = params[:party][:sport]
        params[:party][:establishment_id] = params[:party][:establishment]
        params[:party][:scheduled_for] = build_scheduled_time(params[:party][:scheduled_date], params[:party][:scheduled_time])
        params.require(:party).permit(:name, :description, :private, :scheduled_for, :organizer_id, :establishment_id, :team_id, :sport_id)#, { :attendees=>[] })
      end

      def party_params
        params.require(:party).permit(:name, :description, :private, :scheduled_for, :organizer_id, :establishment_id, :team_id, :sport_id)#, { :attendees=>[] })
      end
    end
  end
end
