module Api
  module V1
    class UsersController < BaseController
      include Devise::Models::DatabaseAuthenticatable
      include ActiveRecord::AttributeAssignment
      respond_to :json
      before_filter :authenticate_user_from_token!
      # before_filter :admin_only!, only: [:index]
      # before_filter :auth_only!, except: [:index]

      def index
        return render json: User.all
      end

      def show
        return render json: User.find(params[:id])
      end

      def update
        @user = User.find(params[:id])
        if current_user.has_role?(:admin) || current_user == @user
          update_params = user_params
          update_params[:sports] = sport_id_list_to_sports_for_update
          update_params[:teams] = team_id_list_to_teams_for_update
          update_params[:reservations] = reservation_id_list_to_reservations_for_update
          if changing_password(update_params)
            update_with_password(update_params)
          else
            update_without_password(update_params)
          end
        else
          return render json: {}, status: 403
        end
      end

      def search_users
        username = params[:username] if params[:username]
        search_location = params[:search_location] if params[:search_location]
        radius = params[:radius] if params[:radius]
        team_id = params[:team_id] if params[:team_id]
        search_results = users_in_the_area(search_location, radius)
        if username
          search_results = search_results & have_name_like(username)
        end
        if team_id
          search_results = search_results & are_fans_of(team_id)
        end
        return render json: search_results
      end

      private

      def are_fans_of(team_id)
        Favorite.where('favoritable_id = ? and favoriter_type = ? and favoritable_type = ?', team_id, "User", "Team").map(&:favoriter_id)
      end

      def have_name_like(username)
        User.where("username ilike '%#{username}%'").map(&:id)
      end

      def users_in_the_area(search_location, radius)
        loc = search_location
        rad = radius || 20
        addresses = Address.near(loc, rad).to_a
        if addresses.any?
          user_ids =  addresses.select{|a| a.addressable_type=='User'}.to_a.map(&:addressable_id)
        end
        return user_ids || []
      end

      def changing_password(update_params)
        update_params[:current_password].present? && update_params[:password].present? && update_params[:password_confirmation].present?
      end

      def update_without_password(update_params)
        if @user.update(update_params)
          return render json: @user
        else
          return render json: { :errors => @user.errors }, status: 422
        end
      end

      def sport_id_list_to_sports_for_update
        update_params = user_params
        if update_params[:sports].present?
          sport_ids = update_params[:sports]
          sports = []
          if sport_ids.any?
            sports = sport_ids.map{|sid| Sport.find_by_id(sid)}.compact.uniq
          end
          sports
        else
          []
        end
      end

      def team_id_list_to_teams_for_update
        update_params = user_params
        if update_params[:teams].present?
          team_ids = update_params[:teams]
          teams = []
          if team_ids.any?
            teams = team_ids.map{|sid| Team.find_by_id(sid)}.compact.uniq
          end
          teams
        else
          []
        end
      end

      def reservation_id_list_to_reservations_for_update
        update_params = user_params
        if update_params[:reservations].present?
          reservation_ids = update_params[:reservations]
          reservations = []
          if reservation_ids.any?
            reservations = reservation_ids.map{|sid| Party.find_by_id(sid)}.compact.uniq
          end
          reservations
        else
          []
        end
      end

      def user_params
        params.require(:user).permit(:username, :first_name, :last_name, :email, :current_password, :password, :password_confirmation, :address, {:sports=>[], :teams=>[], :venues=>[], :reservations=>[], :endorsing_teams=>[]})
      end

      def update_with_password(update_params, *options)
        current_password = update_params.delete(:current_password)

        if update_params[:password].blank?
          update_params.delete(:password)
          update_params.delete(:password_confirmation) if update_params[:password_confirmation].blank?
        end

        if valid_password?(current_password)
          @user.update_attributes(update_params, *options)
          clean_up_passwords
          return render json: @user
        else
          @user.assign_attributes(update_params, *options)
          @user.valid?
          @user.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
          clean_up_passwords
          return render json: @user.errors.messages, status: 422
        end
      end

      def valid_password?(password)
        return false if @user.encrypted_password.blank?
        bcrypt   = ::BCrypt::Password.new(@user.encrypted_password)
        password = ::BCrypt::Engine.hash_secret("#{password}#{self.class.pepper}", bcrypt.salt)
        Devise.secure_compare(password, @user.encrypted_password)
      end
    end
  end
end
