module Api
  module V1
    class AddressesController < BaseController

      def show
        return render json: Address.find(params[:id])
      end

      def create
        create_params = address_params
        @address = Address.new(create_params)
        if @address.save
          return render json: @address
        else
          return render json: { :errors => 'Address not created' }, status: 422
        end
      end

      private

      def address_params
        params.require(:address).permit(:street1, :street2, :city, :state, :zip, :addressable_id, :addressable_type)
      end

    end
  end
end
