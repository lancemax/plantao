class State < ActiveRecord::Base
	has_many :cities
	has_many :hospitals


  	attr_accessible :name, :acronym
end
