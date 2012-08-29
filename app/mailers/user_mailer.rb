class UserMailer < ActionMailer::Base
  default from: "from@example.com"


  	def send_email(user,job)

	  @user = user
	  @job = job
   	  @url  = "www.soprostudio.com.br"
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
