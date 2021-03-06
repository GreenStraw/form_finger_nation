module ApplicationHelper

  def site_name
    @org_name || "BaseApp"
  end

  def check_controller
    controller_name = params[:controller]
    action_name     = params[:action]
    
    # puts "-----------------\n"*2
    # puts controller_name + "/" + action_name
    # puts "1111111111111111111\n"*2
                            # "sessions/new",
                            # "registrations",
                            # "milia/sessions",
                            # "milia/passwords",
                            # "devise/registrations",
                            # "parties",
                            # "sports",
                            # "account",
                            # "vouchers",
                            # "users",
                            # "teams"
    
    restrict_controllers = [
                            "home",
                            "about",
                            "about2",
                            "how",
                            "faq",
                            ]
      
    if restrict_controllers.include?(action_name.to_s)
      return false
    end
    return true
  end

  def site_url
    if Rails.env.production?
      # Place your production URL in the quotes below
      "http://www.BaseApp.com/"
    else
      # Our dev & test URL.
      "http://localhost:3000"
    end
  end

  def meta_author
    "Website Author"
  end

  def meta_description
    "Add your website descripiton here"
  end

  def meta_keywords
    "Add some keywords here"
  end

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    if page_title.empty?
      site_name
    else
      "#{page_title} | #{site_name}"
    end
  end

  def flash_type_to_alert(type)
    case type
    when :notice
      return :success
    when :info
      return :info
    when :alert
      return :warning
    when :error
      return :danger
    else
      return type
    end
  end
  #these are here because Account needs them
  
  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

end