class Hospital < ActiveRecord::Base
	belongs_to :job
	has_many :cities
	has_many :states
  attr_accessible :address, :city_id, :complement, :description, :name, :neighborhood, :photo, :state_id, :zip_code
end
