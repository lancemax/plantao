# -*- coding: utf-8 -*-
class UserMailer < ActionMailer::Base
  default from: "PlantaoNet <noreply@plantaonet.com>"


  	def send_email(user,job)

	  @user = user
	  @job = job
   	  @url = "www.plantaonet.com" 
	# attachments['terms.pdf'] = File.read('/path/terms.pdf')
       mail(:to => user.email,:subject => "[PLANTÃO] "+job.area.name+" - "+job.hospital.name)
       sleep 1
	end


	def send_emails(job)
		@users = User.all
		@users.each do |user|
			UserMailer.send_email(user,job).deliver
		end
	end	

	
	def send_email_ownner_job(job_id,user_id)
		@job = Job.find_all_by_id(job_id)
		@user = User.find_all_by_id(user_id)
	
		UserMailer.send_email_owen_job_deliver(@user[0],@job[0]).deliver  
 	end

 	def send_email_owen_job_deliver(user,job)
 		@user = user
 		@job  = job
 		p @job
		p @user
 		@url  = "www.plantaonet.com" 
    	mail(:to => job.user.email,:subject => "[NOVO CANDIDATO PLANTÃO] "+job.area.name+" - "+job.hospital.name)
       	sleep 1
 	end	


 	def send_email_request(job_id,user_id)
 		@job = Job.find_all_by_id(job_id)
		@job = @job[0]
		p @job
		
 		@requests = Request.find_all_by_job_id(job_id)
 		@requests.each do |request|
 			@user = User.find_all_by_id(request.user_id)
			p @user
 			@user = @user[0]
 			# candidato aceito
 			if @user.id == user_id

				UserMailer.send_email_accept_job(@user,@job).deliver
			#candidato recusado
			else
				UserMailer.send_email_deny_job(@user,@job).deliver
			end
		end
 		
 	end

 	def send_email_accept_job(user,job)
 		@user = user
 		@job  = job
 		@url  = "www.plantaonet.com" 
    	mail(:to => user.email,:subject => "[VOCÊ FOI ELEITO NO PLANTÃO] "+job.area.name+" - "+job.hospital.name)
    end

    def send_email_deny_job(user,job)
		p job
		p user
 		@user = user
 		@job  = job
 		@url  = "www.plantaonet.com" 
    	mail(:to => user.email,:subject => "[RESULTADO DO PLANTÃO] "+job.area.name+" - "+job.hospital.name)
    end


end
