class State < ActiveRecord::Base
	has_many :cities
	has_many :hospitals
	has_many :users

  	attr_accessible :name, :acronym
end
