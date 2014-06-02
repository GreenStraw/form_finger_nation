module Api
  module V1
    class PasswordsController < Devise::PasswordsController

      # POST /resource/password
      def create
        self.resource = resource_class.send_reset_password_instructions(params)
        if successfully_sent?(resource)
          return render json: {}, status: 200
        else
          return render json: {}, status: 422
        end
      end

      # PUT /resource/password
      def update
        self.resource = resource_class.reset_password_by_token(params)
        if resource.errors.empty?
          return render json: {}, status: 200
        else
          return render json: {}, status: 422
        end
      end
    end
  end
end