class Tag < ActiveRecord::Base

  has_many  :plugin_tags,   dependent: :destroy
  has_many  :plugins, through: :plugin_tags, class_name: "SourcemodPlugin"

  validates_presence_of   :name
  validates_uniqueness_of :name

  before_validation   :downcase_name

  scope :tokens,  ->(tokens) {where(name: Tag.tokenize(tokens))}

  scope :used,    lambda {where("tags.id IN (SELECT plugin_tags.tag_id FROM plugin_tags)")}
  scope :unused,  lambda {where("tags.id NOT IN (SELECT plugin_tags.tag_id FROM plugin_tags)")}

  default_scope order('LOWER(tags.name) ASC')

  def downcase_name
    self.name.downcase!
  end

  def to_s
    "#{self.name}"
  end

  def self.tokenize(tokens)
    tokens.downcase!
    tokens.gsub! /\s{2,}/, " "
    tokens.split(/,|\+|\s+/).reject{|t|t.blank?}
  end

  def self.ids_from_tokens(tokens)
    idlist = []
    Tag.tokenize(tokens).each do |token|
      tag = Tag.where(name: token).first_or_create
      idlist << tag.id
    end
    idlist
  end

end
