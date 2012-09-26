class Request < ActiveRecord::Base
	belongs_to :job
	belongs_to :user
	belongs_to :status_request
  attr_accessible :job_id, :user_id, :status_request_id

end
