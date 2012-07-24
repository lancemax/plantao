class State < ActiveRecord::Base
	belongs_to :city


  attr_accessible :name, :acronym
end
