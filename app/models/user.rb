class User < ActiveRecord::Base

  has_many    :translations,  dependent: :destroy
  has_many    :sourcemod_plugins, dependent: :destroy

  has_many    :user_languages, dependent: :destroy
  has_many    :languages, through: :user_languages

  has_many    :web_translations, -> {where imported: false}, :class_name => "Translation"

  validates_presence_of     :provider
  validates_presence_of     :uid
  validates_presence_of     :name

  validates_presence_of     :time_zone
  validates_inclusion_of    :time_zone, :in => ActiveSupport::TimeZone.zones_map { |m| m.name }, :message => "is not a valid Time Zone"

  delegate      :can?, :cannot?, to: :ability

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end

  def guest?
    self.provider.nil?
  end

  def knows_lang?(lang)
    return false if self.user_languages.empty?
    self.languages.include?(lang)
  end

  def ability
    @ability ||= Ability.new(self)
  end

end
