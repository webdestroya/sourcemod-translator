class TagsController < ApplicationController
  # Search for tags by name
  def search
  end

  def index
    @tags = Tag.order("name ASC")

    
  end
  
end
