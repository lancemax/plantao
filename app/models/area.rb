class Area < ActiveRecord::Base
  has_many :users
  has_many :jobs

 
  validates_presence_of :name
  attr_accessible :description, :name

end
