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

    can [:index, :show, :leaders], User

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
      can :destroy, Translation, sourcemod_plugin: {user_id: user.id}

    end

    if user.admin?
      can :manage, :all
    end
  end
end
