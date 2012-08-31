class Admin::AdminController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  check_authorization
  
  layout 'admin/applicationadmin'
end
