=begin
Milia::InviteMember.class_eval do
  def save_and_invite_member()
    if (
        self.email.blank?  ||
        User.where([ "lower(email) = ?", self.email.downcase ]).first
      )
      self.errors.add(:email,"address has already been taken.")
      status = nil
    else
      check_or_set_password()
      status = self.save && self.errors.empty?
    end

    return status
  end
end
=end