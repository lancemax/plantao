class User < ActiveRecord::Base

	belongs_to :area
	belongs_to :push_time


	ROLES = [:admin, :customer]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
  			:name, :phone, :cellphone,:workplace
  # attr_accessible :title, :body

  ROLES.each do |role|
    define_method "is_#{role}?" do
      self.role == "#{role}"
    end
  end
end
