# -*- coding: utf-8 -*-
class Job < ActiveRecord::Base
	belongs_to :area
	belongs_to :hospital
	belongs_to :shift
	belongs_to :user
	has_many :requests
	has_one :request

  attr_accessible :area_id, :date, :dependencies, :description, :hospital_id, :price, :shift_id, :user_id, :request_id
  validates_presence_of :hospital_id, :area_id , :price, :date ,:shift_id
  
  validates :price ,:numericality => {:greater_than => 0, :less_than => 9999.99}
  validates :date, :date => { :after => Time.now - 1.day, :before => Time.now + 1.year }
  
  
  def cancel_job(job_id)
      Job.update(job_id,"request_id" => "0")
  end
end
