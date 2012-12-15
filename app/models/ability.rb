class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    cannot :manage, :all

    unless user.guest? || user.banned?
      can [:show, :create], SourcemodPlugin
      can :manage, SourcemodPlugin, user_id: user.id

      # language list page, and add/remove personal languages
      can [:index, :add, :remove], Language

      # Can view the phrases
      can [:show, :index, :translate, :translate_submit], Phrase

      # Everyone can make a new translation
      can [:new, :create], Translation

      # Only the owner can manage a translation
      can :manage, Translation, user_id: user.id
      can [:delete], Translation, sourcemod_plugin: {user_id: user.id}
    end

    if user.admin?
      can :manage, :all
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
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
