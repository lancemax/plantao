# -*- coding: utf-8 -*-
class Customer::HomeController < ApplicationController

	before_filter :authenticate_user!
  	layout 'customer/applicationcustomer'
  	
  def index
  	authorize! :customer_home, ""
    redirect_to :showJobs
  end

  def show
  	authorize! :customer_home, ""
  end

  def userJobs
  	authorize! :customer_home, ""
  	@jobs = Job.find_all_by_user_id(current_user.id)
    
    
  	 
  end

  def buy
    @packages = Package.all
    @order = Order.new
    
  end


  def setJobRequest
    p params[:job]
    
    respond_to do |format|
      #declara esse requesto como o eleito
      if Job.update(params[:job][:job_id],"request_id" => params[:job][:request_id])
        #declara o request com aceito
        Request.update(params[:job][:request_id],"status_request_id" => 2)
        
        #declara todos os outros como negados
        Request.update_all("status_request_id = 3", ["id != ?",params[:job][:request_id]])
        #notifica candidatos por email
        UserMailer.send_email_request(params[:job][:job_id],params[:job][:request_id])

        @name='Substituto Selecionado com Sucesso'
        @job=params[:job][:job_id]
      else
       @name='Não Foi Possivel executar requerimento'
      end
      format.js
    end

    
  end

  def acceptResire

    respond_to do |format|
      #declara que esse job volta a estar aberto
      if Job.update(params[:job][:job_id],"request_id" => nil)
        #declara esse request como cancelado por desistencia
        Request.update(params[:job][:request_id],"status_request_id" => 6)
        #declara os demais requests como aguardando resposta do moderador
        Request.update_all("status_request_id = 1", ["id != ?",params[:job][:request_id]])
        @name='Desistencia Aceita'
        @job=params[:job][:job_id]
      else
       @name='Não Foi Possivel executar requerimento'
      end
      format.js
    end

  end

  def denyResire

    respond_to do |format|
     
      #declara esse request como aceito sem mais oportunidade de desistencia
      if Request.update(params[:job][:request_id],"status_request_id" => 7)
        @name='Desistencia Negada'
        @job=params[:job][:job_id]
      else
       @name='Não Foi Possivel executar requerimento'
      end
      format.js
    end

  end

end
  