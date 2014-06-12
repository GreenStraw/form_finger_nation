module Api
  module V1
    class AddressesController < BaseController
      before_filter :authenticate_user_from_token!, except: [:create]

      def show
        return render json: Address.find(params[:id])
      end

      def create
        create_params = address_params
        @address = Address.new(create_params)
        if @address.save
          return render json: @address
        else
          return render json: { :errors => @address.errors.full_messages }, status: 422
        end
      end

      def update
        @address = Address.find(params[:id])
        if @address.update!(address_params)
          return render json: @address
        else
          return render json: { :errors => @address.errors.full_messages }, status: 422
        end
      end

      private

      def address_params
        params.require(:address).permit(:street1, :street2, :city, :state, :zip, :addressable_id, :addressable_type)
      end

    end
  end
end
