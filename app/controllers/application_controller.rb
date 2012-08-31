# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery


  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected
   def load_cities
      unless params[:state_id].blank?
       @state = State.find(params[:state_id])
       @cities = @state.cities.collect { |c| [c.name, c.id] }
       render :layout => false
      end
    end

    


  private
  def after_sign_in_path_for(resource_or_scope)
    if current_user.role == 'admin'
      admin_root_path
    else
      customer_root_path
    end
  end

  def setMoney(value)
    if value.gsub!(".","")
      #retira o '.' caso o numero seja maior que 999 (Ex: 1.323,00)
    end
     value.gsub!(",",".")
     value.gsub!("R$ ","")
     value.gsub!("-","")

  end
end
