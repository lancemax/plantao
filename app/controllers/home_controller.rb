# -*- coding: utf-8 -*-
class HomeController < ApplicationController

  def index
  	if !current_user.nil?
  	@user = User.find_all_by_id(current_user.id)
    
    p @user.name
    end	
  end

end
