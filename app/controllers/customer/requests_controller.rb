# -*- coding: utf-8 -*-
class Customer::RequestsController < ApplicationController
  
  before_filter :authenticate_user!
  layout 'customer/applicationcustomer'

  # GET /requests
  # GET /requests.json
  def index
    @requests = Request.find_all_by_user_id(current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @requests }
    end
  end


  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(params[:request])
    @verifica = Request.where(:user_id => current_user.id,:job_id =>@request.job_id).first
    respond_to do |format|
      unless @verifica
        @request.user_id = current_user.id
        @request.status_request_id = 1
         
        if @request.save
          @name='Você se candidatou a esse plantão com sucesso.'
          #passa o id do job para o js
          @save=@request.job_id
          #passa o numero de candidatos pro js
          @num=@request.job.requests.count

          # envia o email para o dono do plantão 
          UserMailer.send_email_ownner_job(@request.job_id,current_user.id)
          
          p @num
        else
          @name='Não foi possivel completar sua requisição'
        end
      end
      format.js
    end 
     
  end

  # PUT /requests/1
  # PUT /requests/1.json
  def update
    @request = Request.find(params[:id])
    respond_to do |format|
      #caso o moderador ainda não tenho escolhido o eleito. então Cancela
      if @request.job.request_id.nil?
        Request.update(@request.id,"status_request_id" => 1)
        UserMailer.send_email_ownner_job(@request.job_id,current_user.id)
        @alterou = 'sim'
        format.js
      else
        @name = 'Seleção para esse Plantão já foi encerrada. Você não pode mais Pleitear'
        format.js
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request = Request.find(params[:id])
    respond_to do |format|
      #caso o moderador ainda não tenho escolhido o eleito. então Cancela
      if @request.job.request_id.nil?
        Request.update(@request.id,"status_request_id" => 4)
        @cancelou = 'sim'
        format.js
      elsif @request.job.request_id == @request.id
        Request.update(@request.id,"status_request_id" => 5)
        @cancelou = 'sim'
        format.js
      else  
        @name = 'Seleção para esse Plantão já foi encerrada. Você não pode mais Desistir'
        format.js
      end
    end
  end
end
