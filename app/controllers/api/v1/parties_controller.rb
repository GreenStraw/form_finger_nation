module Api
  module V1
    class PartiesController < BaseController
      before_filter :authenticate_user_from_token!, only: [:create, :update, :destroy]
      respond_to :json

      def index
        search = params[:query] if params[:query]
        address = params[:address] if params[:address]
        radius = params[:radius] if params[:radius]
        from_date = params[:fromDate].to_date if params[:fromDate]
        to_date = params[:toDate].to_date if params[:toDate]
        results = if address.present?
          search_parties(search, address, radius, from_date, to_date)
        else
          Party.all
        end
        return render json: results
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

      def search_parties(search, address, radius, from_date, to_date)
        bar_ids = establishments_by_address_and_radius(address, radius)

        parties_by_date = Party.where(scheduled_for: from_date.beginning_of_day..to_date.end_of_day)
        parties_in_area = parties_by_date.where(establishment_id: bar_ids)
        results = parties_in_area.where("name ilike '%#{search}%'")
        teams = Team.where("name ilike '%#{search}%'")
        if teams.any?
          results += parties_in_area.where("team_id in (#{teams.map(&:id).join(',')})")
        end
        establishments = Establishment.where("name ilike '%#{search}%'")
        if establishments.any?
          results += parties_in_area.where("establishment_id in (#{establishments.map(&:id).join(',')})")
        end
        results.to_a.compact.uniq
      end

      def establishments_by_address_and_radius(address, radius)
        results = nil
        add = address
        rad = radius || 10
        results = Establishment.near(add, rad)
        results.map(&:id) || []
      end

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
        params[:party][:organizer_id] = params[:party][:organizer]
        params[:party][:team_id] = params[:party][:team]
        params[:party][:sport_id] = params[:party][:sport]
        params[:party][:establishment_id] = params[:party][:establishment]
        params[:party][:attendee_ids] = params[:party][:attendees]
        params[:party][:scheduled_for] = build_scheduled_time(params[:party][:scheduled_date], params[:party][:scheduled_time])
        params.require(:party).permit(:name, :description, :private, :scheduled_for, :organizer_id, :establishment_id, :team_id, :sport_id, { :attendee_ids=>[] })
      end

      def party_params
        params.require(:party).permit(:name, :description, :private, :scheduled_for, :organizer_id, :establishment_id, :team_id, :sport_id, { :attendee_ids=>[] })
      end
    end
  end
end
