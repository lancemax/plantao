class Hospital < ActiveRecord::Base
	has_many :jobs
	belongs_to :city
	belongs_to :state

  attr_accessible :address, :city_id, :complement, :description, :name, :neighborhood, :photo, :state_id, :zip_code
  validates_presence_of :name,:address, :neighborhood, :zip_code, :city_id, :state_id
end
