class PackagesController < InheritedResources::Base
	before_filter :authenticate_user!
	def index

		
	end
end
