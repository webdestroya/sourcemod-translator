module TagsHelper

  def all_tag_list
    Tag.select("name").order("name ASC").collect{|x|x.name}.join(",")
  end

end
