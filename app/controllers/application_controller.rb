class ApplicationController < ActionController::Base
  # By default, user should be authenticate on all routes
  before_action :authenticate_user!
end
