class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # SessionsHelper isautomatically included in Rails views
  #
  # by including the module into the base class of all controllers
  # (the Application controller), we arrange to make them available in
  # our controllers as well
  include SessionsHelper
end
