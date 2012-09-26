class Package < ActiveRecord::Base
	has_many :orders
  attr_accessible :amount, :name, :price, :image

  has_attached_file :image, 
	:styles => { :small=> ["250"], :medium =>["400"]},
	:path => ":rails_root/public/images/uploads/:class/:id/:style_:basename.:extension",
	:url => "/images/uploads/:class/:id/:style_:basename.:extension",
	:default_url => "/images/default-package.jpg"

  validates :price ,:numericality => {:greater_than => 0, :less_than => 9999.99}
	validates :amount,:presence => true, :numericality => true
	validates_presence_of :amount, :name, :price 

end
