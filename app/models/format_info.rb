class FormatInfo < ActiveRecord::Base
  belongs_to   :phrase

  #validates_presence_of   :phrase_id

  validates_presence_of       :position
  validates_numericality_of   :position, only_integer: true, greater_than: 0

  validates_presence_of       :format_class
  #validates_inclusion_of      :format_class, :in => %w(T L N b u d i x X f s c t)
  # "c,b,d,i,u,f,s,T,t,X,x,%" 

  scope :has_description,  -> {where("format_infos.description IS NOT NULL")}

  def type
    case self.format_class
    when "c"
      "Character"
    when "b"
      "Binary"
    when "u"
      "Unsigned integer"
    when "d", "i"
      "Integer"
    when "f"
      "Floating point"
    when "s"
      "String"
    when "x", "X"
      "Hexadecimal"
    when "t"
      "Phrase"
    when "N"
      "Client name"
    when "L"
      "Client log"
    else # T
      "INVALID(#{self.format_class})"
    end
  end

end
