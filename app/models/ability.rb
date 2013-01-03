class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    cannot :manage, :all

    # Everyone can make a new translation
    can [:index, :show], Translation
    can [:index, :show, :export, :download], SourcemodPlugin

    # Can view the phrases
    can [:show, :index], Phrase

    can [:index, :show], User

    unless user.guest? || user.banned?
      can :create, SourcemodPlugin
      can :manage, SourcemodPlugin, user_id: user.id

      # language list page, and add/remove personal languages
      can [:index, :add, :remove], Language

      can [:translate, :translate_submit], Phrase
      can [:manage], Phrase, sourcemod_plugin: {user_id: user.id}

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
