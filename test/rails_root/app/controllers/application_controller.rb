class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  include BlueLightSpecial::Authentication
  before_filter :authenticate
end
