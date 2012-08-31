class Package < ActiveRecord::Base
	has_many :orders
  attr_accessible :amount, :name, :price, :image
  
  before_save :set_money

  has_attached_file :image, 
	:styles => { :small=> ["250"], :medium =>["400"]},
	:path => ":rails_root/public/images/uploads/:class/:id/:style_:basename.:extension",
	:url => "/images/uploads/:class/:id/:style_:basename.:extension",
	:default_url => "/images/default-package.jpg"

	validates :amount, :price, 
            :presence => true, 
            :numericality => true
	validates :amount, :name, :price ,:presence =>true

	def set_money
    if self.price.gsub!(".","")
      #retira o '.' caso o numero seja maior que 999 (Ex: 1.323,00)
    end
     self.price.gsub!(",",".")
     self.price.gsub!("R$ ","")
     self.price.gsub!("-","")

  end
end
