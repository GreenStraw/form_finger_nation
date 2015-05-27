class Api::V1::PasswordsController < Devise::PasswordsController

  def create
    self.resource = resource_class.send_reset_password_instructions(params)
    if successfully_sent?(resource)
      return render json: {}, status: 200
    else
      return render json: { :errors => resource.errors.full_messages }, status: 422
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(params)
    if resource.errors.empty?
      return render json: {}, status: 200
    else
      return render json: { :errors => resource.errors.full_messages }, status: 422
    end
  end

end
