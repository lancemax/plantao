# -*- coding: utf-8 -*-
class UserMailer < ActionMailer::Base
  default from: "PlantaoNet <noreply@plantaonet.com>"
  ACEITO = 2 

  	def send_email(user,job)

	  @user = user
	  @job = job
   	  @url = "www.plantaonet.com" 
	# attachments['terms.pdf'] = File.read('/path/terms.pdf')
       mail(:to => user.email,:subject => "[PLANTÃO] "+job.area.name+" - "+job.hospital.name)
	end


	def send_emails(job)
		@users = User.all
		@users.each do |user| 
		 	if Rails.env == 'production' 
				UserMailer.delay.send_email(user,job)
			end
		end
	end	

	
	def send_email_ownner_job(job_id,user_id)
		@job = Job.find_all_by_id(job_id)
		@user = User.find_all_by_id(user_id)
		if Rails.env == 'production' 
			UserMailer.delay.send_email_ownner_job_deliver(@user[0],@job[0])
		end
 	end

 	def send_email_ownner_job_deliver(user,job)
 		@user = user
 		@job  = job
 		@url  = "www.plantaonet.com" 
    	mail(:to => job.user.email,:subject => "[NOVO CANDIDATO] "+user.name+" - "+ job.area.name + "("+ job.date.strftime("%d/%m/%Y") +")")
 	end	


 	def send_email_request(job_id)
		
 		@requests = Request.find_all_by_job_id(job_id)
 		@requests.each do |request|
 			
 			if Rails.env == 'production' 
	 			# candidato aceito
	 			if request.status_request_id == ACEITO 
					UserMailer.delay.send_email_accept_job(request.user,@job)
				#candidato recusado
				else
					UserMailer.delay.send_email_deny_job(request.user,@job)
				end
			end
		end
 		
 	end

 	def send_email_accept_job(user,job)
 		@user = user
 		@job  = job
 		@url  = "www.plantaonet.com" 
    	mail(:to => user.email,:subject => "[VOCÊ FOI ELEITO NO PLANTÃO] "+job.area.name+" - "+job.hospital.name + "("+ job.date.strftime("%d/%m/%Y")  +")")
    end

    def send_email_deny_job(user,job)
 		@user = user
 		@job  = job
 		@url  = "www.plantaonet.com" 
    	mail(:to => user.email,:subject => "[RESULTADO DO PLANTÃO] "+job.area.name+" - "+job.hospital.name + "("+ job.date.strftime("%d/%m/%Y")  +")")
    end


end
