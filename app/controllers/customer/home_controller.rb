# -*- coding: utf-8 -*-
class Customer::HomeController < ApplicationController

	before_filter :authenticate_user!
  	layout 'customer/applicationcustomer'
  	
  def index
  	authorize! :customer_home, ""
  end

end
