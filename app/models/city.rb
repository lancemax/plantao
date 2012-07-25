class City < ActiveRecord::Base
	belongs_to :state
	has_many :hospitals
  attr_accessible :name, :state_id
end
