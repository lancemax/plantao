class Customer::PackagesController < ApplicationController
	before_filter :authenticate_user!

	def index
		@packages = Package.all
    	@order = Order.new
		
	end


end
