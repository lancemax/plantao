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
  
 scope :hospital_id, lambda { |hospital_id|
    where(:hospital_id =>hospital_id)
  }

  scope :area_id, lambda { |area_id|
    where(:area_id =>area_id)
  }

  scope :shift_id, lambda { |shift_id|
    where(:shift_id =>shift_id)
  }

  scope :price, lambda { |price|
    setMoney(price)
    where("price >= ?",price)
  }
  
  def cancel_job(job_id)
      Job.update(job_id,"request_id" => "0")
  end

  def self.setMoney(value)
    #retira o '.' caso o numero seja maior que 999 (Ex: 1.323,00)
    if value.gsub!(".","");  end
    
     value.gsub!(",",".")
     value.gsub!("R$ ","")
     value.gsub!("-","")

  end

  def self.reminderMorning
      # relembrar plantões abertos não pleiteados

      #lembrar moderador de encerrar plantão pleiteado
      @jobs = Job.joins(:requests).where("date between ? and ? and request_id != ? and shift_id = ?",1.days.ago,Time.now,'0', CONS::SHIFT[:MANHA] )
      @jobs.each do |job| 
        Usermailer.send_email_relembra_encerra_plantao(job)
        p "relembra plantao manha"
        p job
        p Time.now
      end
  end

  def self.reminderAfternoon
      @jobs = Job.joins(:requests).where("date between ? and ? and request_id != ? and shift_id = ?",1.days.ago,Time.now,'0', CONS::SHIFT[:TARDE] )
      @jobs.each do |job| 
        Usermailer.send_email_relembra_encerra_plantao(job)
        p "relembra plantao tarde"
        p job
        p Time.now
      end
  end

  def self.reminderNight
      @jobs = Job.joins(:requests).where("date between ? and ? and request_id != ? and shift_id = ?",1.days.ago,Time.now,'0', CONS::SHIFT[:NOITE] )
      @jobs.each do |job| 
        Usermailer.send_email_relembra_encerra_plantao(job)
        p "relembra plantao noite"
        p job
        p Time.now
      end
  end


  def self.closeJob
       @jobs = Job.where("date =  ? and  request_id is null ",Time.now - 1.day )
       @jobs.each do |job| 
        @request = Request.where("job_id = ? and  status_request_id =? ",job.id ,CONS::REQUEST[:AGUARDANDO_RESPOSTA] )
        if !@request.nil?
          Job.update(job.id,:request_id => '-1')
          @user = User.new
          p  "Consome creditos user:"
          p job.user_id
          @user.consume_credits(job.user_id)
        end
      end
    
  end

end
