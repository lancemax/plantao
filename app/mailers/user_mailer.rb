# -*- coding: utf-8 -*-	
class UserMailer < ActionMailer::Base
  default from: "PlantaoNet <noreply@plantaonet.com>", :return_path => 'contato@plantaonet.com'
  CONS::REQUEST[:ACEITO] = 2 
  
  #STATUS DE REQUUESTS
  CONS::REQUEST[:AGUARDANDO_RESPOSTA] = 1
  CONS::REQUEST[:DESISTENCIA] = 5
  	def send_email(user,job)

	  @user = user
	  @job = job
   	  @url = "www.plantaonet.com" 
	# attachments['terms.pdf'] = File.read('/path/terms.pdf')
       mail(:to => user.email,:subject => "[PLANTÃO] "+job.area.name+" - "+job.hospital.name + "(" + job.date.strftime("%d/%m/%Y") +")")
	end


	def send_emails(job)
		@users = User.all
		@users.each do |user| 
		 	if Rails.env == 'production' 
				UserMailer.delay.send_email(user,job)
			end
		end
	end	

	# envio de email para o caso de edição de plantão
	def send_emails_edit(job)
		@users = User.all
		@users.each do |user| 
		 	if Rails.env == 'production' 
		 		
				UserMailer.delay.send_email(user,job)
			end
		end
	end	

	
	def send_email_ownner_job(job_id,user_id,status)
		@job = Job.find_all_by_id(job_id)
		@user = User.find_all_by_id(user_id)
		if Rails.env == 'production' 
			if(status == CONS::REQUEST[:AGUARDANDO_RESPOSTA])
				UserMailer.delay.send_email_ownner_job_deliver(@user[0],@job[0])
			elsif (status == CONS::REQUEST[:DESISTENCIA])
				UserMailer.delay.send_email_ownner_job_desistir_deliver(@user[0],@job[0])
				# enviar pros candidatos que voltaram a estar concorrendo
				@requests = Request.find_all_by_job_id(job_id)
	 			@requests.each do |request|				
	 				if request.user_id != @user[0].id
	 					UserMailer.delay.send_email_reopen_job(request.user,request.job)
	 				end
				end
			end
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
	 			# candidato CONS::REQUEST[:ACEITO]
	 			if request.status_request_id == CONS::REQUEST[:ACEITO] 
					UserMailer.delay.send_email_accept_job(request.user,request.job)
				#candidato recusado
				else
					UserMailer.delay.send_email_deny_job(request.user,request.job)
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

    def send_email_ownner_job_desistir_deliver(user,job)
    	@user = user
 		@job  = job
 		@url  = "www.plantaonet.com" 
    	mail(:to => job.user.email,:subject => "[DESISTÊNCIA] "+user.name+" - "+ job.area.name + "("+ job.date.strftime("%d/%m/%Y") +")")
    	
    end

    def send_email_reopen_job(user,job)
    	@user = user
 		@job  = job
 		@url  = "www.plantaonet.com" 
    	mail(:to => job.user.email,:subject => "[REABERTURA PLANTÃO] "+job.area.name+" - "+job.hospital.name + "("+ job.date.strftime("%d/%m/%Y") +")")
    end

    def send_email_admin_request(hospital)
    	if Rails.env == 'production' 
	    	UserMailer.delay.send_email_create_hospital(hospital)
    	end
    end

    def send_email_create_hospital(hospital)
    	@hospital = hospital
 		@url  = "www.plantaonet.com" 
 		@users = User.find_all_by_role("admin")
 		@users.each do |user|
	    	mail(:to => user.email,:subject => "[CRIAÇÃO/EDIÇÃO DE HOSPITAL] "+hospital.name + "("+ hospital.created_at.strftime("%d/%m/%Y") +")")
    	end
    end

end
