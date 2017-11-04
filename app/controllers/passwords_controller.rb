=begin
class PasswordsController < Milia::PasswordsController
  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    root_path if is_navigational_format?
  end

end  # class
=end