class Job < ActiveRecord::Base
	belongs_to :area
	belongs_to :hospital
	belongs_to :shift
	belongs_to :user
	has_many :requests
  attr_accessible :area_id, :date, :dependencies, :description, :hospital_id, :price, :shift_id, :user_id
end
