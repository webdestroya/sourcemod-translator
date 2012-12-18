class UsersController < ApplicationController
  load_and_authorize_resource

  before_action :set_user, only: [:show]


  def index

  end


  def show

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

end
