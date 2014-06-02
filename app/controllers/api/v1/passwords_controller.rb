module Api
  module V1
    class PasswordsController < Devise::PasswordsController

      # POST /resource/password
      def create
        puts params.inspect
        self.resource = resource_class.send_reset_password_instructions(params)
        puts resource_params.inspect
        if successfully_sent?(resource)
          puts "sent success"
          return render json: {}, status: 200
        else
          puts "sent failed"
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