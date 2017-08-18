module DeviseHelpers

  def login(role=nil)
    if role.nil?
      request.env['warden'].stub(:authenticate!).and_throw(:warden, {:scope => :user})
      controller.stub :current_user => nil
    end
  end

  def logout
    sign_out current_user if current_user
    @current_user = nil
    request.env['warden'].stub(:authenticate!).and_throw(:warden, {:scope => :user})
    controller.stub :current_user => nil
  end

  def current_user
    @current_user
  end

  def should_deny_access
    response.should redirect_to(root_url)
  end

end
