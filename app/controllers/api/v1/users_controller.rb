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
          if changing_password(user_params)
            update_with_password(user_params)
          else
            update_without_password(user_params)
          end
        else
          return render json: { :errors => @user.errors.full_messages }, status: 403
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
        User.where("username ilike ?", "%#{username}%").map(&:id)
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

      def user_params
        params.require(:user).permit(:username, :first_name, :last_name, :email, :current_password, :password, :password_confirmation, :address, {:sport_ids=>[], :team_ids=>[], :venue_ids=>[], :reservation_ids=>[], :endorsing_team_ids=>[]})
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
