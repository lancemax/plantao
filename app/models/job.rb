class Job < ActiveRecord::Base
	has_many :areas
	has_many :hospitals
	has_many :shifts
  attr_accessible :area_id, :date, :dependencies, :description, :hospital_id, :price, :shift_id
end
