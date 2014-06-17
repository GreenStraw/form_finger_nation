class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_tenant

  force_ssl if: :ssl_configured?
  def ssl_configured?
    # force all requests to use ssl if in produciton environment
    # Rails.env.production?
    false
  end

  ##    milia defines a default max_tenants, invalid_tenant exception handling
  ##    but you can override these if you wish to handle directly
  rescue_from ::Milia::Control::MaxTenantExceeded, :with => :max_tenants
  rescue_from ::Milia::Control::InvalidTenantAccess, :with => :invalid_tenant

  private

  # after logout direct viewer to new user sign in path
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  # later this actions will read from a subdomain value
  # and load the appropriate tenant record
  def set_current_tenant
    @current_tenant = Tenant.first or raise "run db:seed to create first tenant record"
    Tenant.set_current_tenant(@current_tenant)
  end

  # optional callback for post-authenticate_tenant! processing
  def callback_authenticate_tenant
    @org_name = ( Tenant.current_tenant.nil?  ?
      "BaseApp"   :
      Tenant.current_tenant.name
    )
    # set_environment or whatever else you need for each valid session
  end

  def authenticate_user_from_token!
    user_email = request.headers['auth-email'].presence
    user_token = request.headers['auth-token'].presence
    return render json: {}, status: 401 unless user_email && user_token
    user       = user_email && User.find_by_email(user_email)

    if user && Devise.secure_compare(user.authentication_token, user_token)
      sign_in user, store: false
    else
      return render json: {}, status: 401
    end
  end

end
