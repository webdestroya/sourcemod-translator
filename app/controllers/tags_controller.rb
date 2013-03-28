class TagsController < ApplicationController
  # Search for tags by name
  def search
  end

  def index
    @tags = Tag.used.order("name ASC")
  end
  
end
