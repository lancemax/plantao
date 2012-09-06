class UserMailer < ActionMailer::Base
  default from: "Plantao Net <noreply@plantaonet.com>"


  	def send_email(user,job)

	  @user = user
	  @job = job
   	  @url = "www.plantaonet.com" 
	# attachments['terms.pdf'] = File.read('/path/terms.pdf')
       mail(:to => user.email,:subject => job.description)
       sleep 1
	end


	def send_emails(job)
		@users = User.all
		@users.each do |user|
			UserMailer.send_email(user,job).deliver
		end
	end	


	
end
