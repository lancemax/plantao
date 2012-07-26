class Hospital < ActiveRecord::Base
	has_many :jobs
	belongs_to :city
	belongs_to :state

	attr_accessible :address, :city_id, :complement, :description, :name, :neighborhood, :state_id, :zip_code, :image
	validates_presence_of :name,:address, :neighborhood, :zip_code, :city_id, :state_id 

	has_attached_file :image, 
	:styles => { :small=> ["250"], :medium =>["400"]},
	:path => ":rails_root/public/images/uploads/:class/:id/:style_:basename.:extension",
	:url => "/images/uploads/:class/:id/:style_:basename.:extension",
	:default_url => "/images/default-hospital.jpg"
end
