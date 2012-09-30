# -*- coding: utf-8 -*-
class User < ActiveRecord::Base

	belongs_to :area
  belongs_to :state
  has_many :jobs
	belongs_to :push_time
  has_many :requests
  before_create :verificaPromocao
  before_save :verificaCrm

	ROLES = [:admin, :customer]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable 
  devise :database_authenticatable, :registerable, :omniauthable ,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
  			:name, :phone, :cellphone,:workplace ,:provider, :uid, :area_id, :push_time_id, :minor_value, :state_id , :crm
  # attr_accessible :title, :body


  def verificaPromocao
    @promo= Promotions.new
    self.credits =  @promo.getPromotion
  end

  def verificaCrm
    require 'nokogiri'
    require 'open-uri'

    url = "http://portal.cfm.org.br/index.php?medicosNome=&medicosCRM=#{self.crm}&medicosUF=#{self.state.acronym}&medicosSituacao=&medicosTipoInscricao=&medicosEspecialidade=&buscaEfetuada=true&option=com_medicos#buscaMedicos"
    p url
    doc = Nokogiri::HTML(open(url))
    puts doc.css(".row0 span").text
    cont = 0 
    aux = []
    doc.css(".row0 span").each do |span|
      aux[cont] = span.to_s.gsub(%r{</?[^>]+?>}, '')
      cont=cont+1

    end

    if !self.crm.nil? && !self.state.nil?
      if self.crm != aux[2].to_i || self.state.acronym != aux[3] || aux[1] != "Ativo" 
       errors.add(:crm, "( Crm / UF inválidos, ou Médico inativo )")
       return false
      end  
    end
    
  end


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

  def consume_credits(user_id)
    if User.find(user_id).try(:decrement!,:credits,1)
      return true
    else
      return false
    end
  end

  def payback_credits(user_id)
    if User.find(user_id).try(:increment!,:credits,1)
      return true
    else
      return false
    end
  end

end
