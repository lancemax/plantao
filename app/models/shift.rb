class Shift < ActiveRecord::Base
	belongs_to :job
  attr_accessible :name
end
