class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => "Sorry, you don't have access to do that"
  end

  helper_method :tempodb

  def tempodb
    @tempodb ||= TempoDB::Client.new(ENV['TEMPODB_API_KEY'], ENV['TEMPODB_API_SECRET'])
  end


  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

end
