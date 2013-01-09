class FormatInfo < ActiveRecord::Base
  belongs_to   :phrase

  validates_presence_of   :position

  validates_presence_of   :format_class
  validates_inclusion_of  :format_class, :in => %w(d i x f s c t)


  def type
    case self.format_class
    when "c"
      "Characters"
    when "d"
      "Digits"
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
