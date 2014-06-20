class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
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

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
