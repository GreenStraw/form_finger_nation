class Ability
  include CanCan::Ability

  def initialize(user)
    can :comment_as, Venue do |venue|
      user.has_role?(:manager, venue)
    end
  end
end
