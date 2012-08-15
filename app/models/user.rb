class User < ActiveRecord::Base

	belongs_to :area
  has_many :jobs
	belongs_to :push_time
  has_many :requests


	ROLES = [:admin, :customer]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable 
  devise :database_authenticatable, :registerable, :omniauthable ,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
  			:name, :phone, :cellphone,:workplace ,:provider, :uid, :area_id, :push_time_id, :minor_value
  # attr_accessible :title, :body

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:email => auth.info.email).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20]
                           )
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
        user = User.create(name: data["name"],
             provider:"google",
             email: data["email"],
             password: Devise.friendly_token[0,20]
            )
    end
    user
  end

  ROLES.each do |role|
    define_method "is_#{role}?" do
      self.role == "#{role}"
    end
  end

  #alterar dados sem necessidade de digitar a senha (Devise)
  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
    update_attributes(params) 
  end


end
