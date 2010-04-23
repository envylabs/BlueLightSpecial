class ApplicationController < ActionController::Base
  include BlueLightSpecial::Authentication
  protect_from_forgery
  layout 'application'
end
