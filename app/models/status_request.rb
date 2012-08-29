class StatusRequest < ActiveRecord::Base
	has_many :requests
    attr_accessible :name
end
