class PushTime < ActiveRecord::Base
	has_many :users
  attr_accessible :name, :value
end
