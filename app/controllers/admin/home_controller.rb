class Admin::HomeController < ApplicationController

  before_filter :authenticate_user!
  inherit_resources
  layout 'admin/applicationadmin'
  
  def index
    authorize! :admin_home, ""
  end

  def listUsers
  	@search = User.where(:role => "customer").search(params[:search])
	  @users = @search.paginate(:page => params[:page],:per_page => 50).order("name ASC")    
  end	

  def showUser

  	
  end

  def editUser
  	@user = User.find(params[:user])
	p @user.email
  end

  def deleteUser
  	
  end


end
