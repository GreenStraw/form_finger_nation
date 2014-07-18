class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role?(:team_admin)
      can :update, :add_host, :remove_host, Team do |team|
        user.has_role?(:team_admin, team)
      end
    end

    if user.has_role?(:admin)
      can :manage, :all
    else
      can :read, :all
      can :subscribe_user, Team
      can :unsubscribe_user, Team
      can :subscribe_user, Sport
      can :unsubscribe_user, Sport
      can :create, Party
      can :packages, Venue

      can :update, User do |u|
        user.id == u.id
      end

      can :follow_user, User do |u|
        user.id == u.id
      end

      can :unfollow_user, User do |u|
        user.id == u.id
      end

      can :update, Party do |party|
        user.id == party.organizer_id || user.has_role?(:manager, party)
      end

      can :destroy, Party do |party|
        user.id == party.organizer_id || user.has_role?(:manager, party)
      end

      can :invite, Party do |party|
        user.id == party.organizer_id || user.has_role?(:manager, party)
      end

      can :update, Party do |party|
        user.has_role?(:manager, party.venue) if party.venue.present?
      end

      can :destroy, Comment do |comment|
        (user.id == comment.commenter_id && comment.commenter_type == 'User') || user.has_role?(:manager, comment.commenter)
      end

      can :update, Comment do |comment|
        (user.id == comment.commenter_id && comment.commenter_type == 'User') || user.has_role?(:manager, comment.commenter)
      end

      can :create, Comment do |comment|
        (user.id == comment.commenter_id && comment.commenter_type == 'User') || user.has_role?(:manager, comment.commenter)
      end

      can :update, Package do |package|
        user.has_role?(:manager, package.venue)
      end

      can :destroy, Package do |package|
        user.has_role?(:manager, package.venue)
      end
    end
  end
end
