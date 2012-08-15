# -*- coding: utf-8 -*-
class Customer::HomeController < ApplicationController

	before_filter :authenticate_user!
  	layout 'customer/applicationcustomer'
  	
  def index
  	authorize! :customer_home, ""
  end

  def show
  	authorize! :customer_home, ""
  end

  def userJobs
  	authorize! :customer_home, ""
  	@jobs = Job.find_all_by_user_id(current_user.id)
    
    
  	 
  end

  def setJobRequest
    p params[:job]
    
    respond_to do |format|
      if Job.update(params[:job][:job_id],"request_id" => params[:job][:request_id])
        @name='Substituto Selecionado com Sucesso'
        #TODO: redirecionar pra algum lugar que ainda não sei qual
        #@url='jobs/'+params[:job][:job_id]
      else
       @name='Não Foi Possivel executar requerimento'
      end
      format.js
    end

    
  end

end
