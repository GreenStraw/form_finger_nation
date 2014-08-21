class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role?(:team_admin, :any)
      can [:update, :add_host, :remove_host], Team do |team|
        user.has_role?(:team_admin, team)
      end
    end

    if user.has_role?(:manager, :any)
      can [:add_package, :remove_package], Party do |p|
        user.has_role?(:manager, p.venue)
      end

      can [:verify_party, :unverify_party], Venue, Party do |v, p|
        user.has_role?(:manager, v) && v.upcoming_parties.includes?(p)
      end
    end

    if user.has_role?(:admin)
      can :manage, :all
    else
      can :read, :all
      can [:subscribe_user, :subscribe, :unsubscribe_user, :unsubscribe], Team
      can [:subscribe_user, :unsubscribe_user], Sport
      can :packages, Venue

      can [:create, :rsvp, :unrsvp, :search, :invite, :by_organizer, :by_attendee, :purchase_package], Party

      can [:update, :destroy, :invite], Party do |party|
        user.id == party.organizer_id || user.has_role?(:manager, party)
      end

      can :update, Party do |party|
        user.has_role?(:manager, party.venue) if party.venue.present?
      end

      can [:update, :follow_user, :unfollow_user], User do |u|
        user.id == u.id
      end

      can [:destroy, :update, :create], Comment do |comment|
        (user.id == comment.commenter_id && comment.commenter_type == 'User') || user.has_role?(:manager, comment.commenter)
      end

      can [:update, :destroy], Package do |package|
        user.has_role?(:manager, package.venue)
      end

      can [:create, :by_user], Voucher
      can [:show, :update, :redeem], Voucher do |voucher|
        user.id == voucher.user_id
      end
      can :show, Voucher do |voucher|
        user.has_role?(:manager, voucher.package.venue)
      end
    end

  end
end
