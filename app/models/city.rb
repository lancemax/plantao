class City < ActiveRecord::Base
	has_many :states
  attr_accessible :name, :state_id
end
