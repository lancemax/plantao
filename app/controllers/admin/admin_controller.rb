class Admin::AdminController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  check_authorization
  
  layout 'admin/applicationadmin'

  def setMoney(value)
    if value.gsub!(".","")
      #retira o '.' caso o numero seja maior que 999 (Ex: 1.323,00)
    end
     value.gsub!(",",".")
     value.gsub!("R$ ","")
     value.gsub!("-","")

  end
end
