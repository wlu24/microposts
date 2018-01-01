class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # SessionsHelper isautomatically included in Rails views
  #
  # by including the module into the base class of all controllers
  # (the Application controller), we arrange to make them available in
  # our controllers as well
  include SessionsHelper

  private

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
