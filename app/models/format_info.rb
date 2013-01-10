class FormatInfo < ActiveRecord::Base
  belongs_to   :phrase

  #validates_presence_of   :phrase_id

  validates_presence_of       :position
  validates_numericality_of   :position, only_integer: true, greater_than: 0

  validates_presence_of       :format_class
  validates_inclusion_of      :format_class, :in => %w(d i x f s c t)


  def type
    case self.format_class
    when "c"
      "Character"
    when "d"
      "Digit"
    when "i"
      "Integer"
    when "f"
      "Floating point"
    when "s"
      "String"
    when "x"
      "Hexadecimal"
    when "t"
      "Phrase"
    end
  end

end
