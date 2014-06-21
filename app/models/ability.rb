class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user
    end

    if user.has_role?(:admin)
      can :manage, :all
    else
      can :read, :all
      can :create, Party
    end

    can :manage, Party do |party|
      user.id == party.organizer_id || user.has_role?(:manager, party)
    end

    can :manage, Team do |team|
      user.has_role?(:team_admin, team)
    end

    can :manage, Comment do |comment|
      (user.id == comment.commenter_id && comment.commenter_type == 'User') || user.has_role?(:manager, comment.commenter)
    end

    can :manage, Package do |package|
      user.has_role?(:manager, package.venue)
    end

    can :add_host, Team do |team|
      user.has_role?(:team_admin, team)
    end

    can :remove_host, Team do |team|
      user.has_role?(:team_admin, team)
    end
  end
end
