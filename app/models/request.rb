class Request < ActiveRecord::Base
	belongs_to :job
	belongs_to :user
  attr_accessible :job_id, :user_id
end
