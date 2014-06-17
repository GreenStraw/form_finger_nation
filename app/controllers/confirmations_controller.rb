class ConfirmationsController < Devise::ConfirmationsController

  skip_before_action :authenticate_tenant!
  before_action      :set_confirmable, :only => [ :update, :show ]

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      # set_flash_message(:notice, :confirmed) if is_flashing_format?
      return render json: resource, status: 200
    else
      return render json: resource.errors, status: 422
    end
  end
  # PUT /resource/confirmation
  # entered ONLY on invite-members usage to set password at time of confirmation
  def update
    if @confirmable.attempt_set_password(user_params)
      # this section is patterned off of devise 3.2.5 confirmations_controller#show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?
      if resource.errors.empty?
        log_action( "invitee confirmed" )
        set_flash_message(:notice, :confirmed) if is_flashing_format?
          # sign in automatically
        # sign_in_tenanted_and_redirect(resource)
        return render json: resource, status: 200
      else
        log_action( "invitee confirmation failed" )
        # respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
        return render json: resource.errors, status: 422
      end
    else
      log_action( "invitee password set failed" )
      prep_do_show()  # prep for the form
      # respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :show }
      return render json: resource.errors, status: 422
    end  # if..then..else passwords are valid
  end

  protected

  def set_confirmable()
    original_token = params[:confirmation_token]
    confirmation_token = Devise.token_generator.digest(User, :confirmation_token, original_token)
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
  end

  def user_params()
    params.require(:user).permit(:password, :password_confirmation, :confirmation_token)
  end

end  # class
