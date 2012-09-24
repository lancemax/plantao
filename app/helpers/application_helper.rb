module ApplicationHelper

	def to_real(valor)
 		number_to_currency(valor,:unit => "R$", :separator => ",", :delimiter => "")
	end

	#captcha
	include Rack::Recaptcha::Helpers

end
