class Order < ActiveRecord::Base
	belongs_to :status_order
	belongs_to :package
  attr_accessible :package_id, :status_order_id, :user_id

  before_save :set_package_price

	def set_package_price
      self.price = self.package.price
   end
end
