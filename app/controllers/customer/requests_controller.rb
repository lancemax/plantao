# -*- coding: utf-8 -*-
class Customer::RequestsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :pode_candidatar , :only => [:create,:update]
  before_filter :jobExpirou , :only => [:new, :create, :edit, :update , :destroy]  

  
  CONS::REQUEST[:AGUARDANDO_RESPOSTA] = 1
  CONS::REQUEST[:CANCELADO] = 4
  CONS::REQUEST[:DESISTENCIA] = 5
  # GET /requests
  # GET /requests.json
  def index
    @requests = Request.paginate(:page => params[:page], :per_page => 8).order("created_at DESC").find_all_by_user_id(current_user.id)

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
        @request.status_request_id = CONS::REQUEST[:AGUARDANDO_RESPOSTA]
         
        if @request.save
          @name='Você se candidatou a esse plantão com sucesso.'
          #passa o id do job para o js
          @save=@request.job_id
          #passa o numero de candidatos pro js
          @num=@request.job.requests.count

          # envia o email para o dono do plantão  
          if Rails.env == 'production' 
            UserMailer.send_email_ownner_job(@request.job_id,current_user.id,CONS::REQUEST[:AGUARDANDO_RESPOSTA])
          end
          
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
      # se o plantao ainda nao foi encerrado pode repleitear
      if @request.job.request_id.nil?
        Request.update(@request.id,"status_request_id" => CONS::REQUEST[:AGUARDANDO_RESPOSTA])
        if Rails.env == 'production'
          UserMailer.send_email_ownner_job(@request.job.id,current_user.id,CONS::REQUEST[:AGUARDANDO_RESPOSTA])
        end
        @alterou = @request.job.id
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
        Request.update(@request.id,"status_request_id" => CONS::REQUEST[:CANCELADO])
        @cancelou = @request.job.id
        format.js
      # solicita CONS::REQUEST[:DESISTENCIA] ao moderador e envia o email para o mesmo  
      elsif @request.job.request_id == @request.id

        Request.update(@request.id,"status_request_id" => CONS::REQUEST[:DESISTENCIA])
         #declara que esse job volta a estar aberto
        Job.update(@request.job_id,"request_id" => nil)
        #declara os demais requests como aguardando resposta do moderador
        Request.update_all(["status_request_id = ?" , CONS::REQUEST[:AGUARDANDO_RESPOSTA] ] , 
                          ["status_request_id = ? and job_id = ?",CONS::REQUEST[:NEGADO],@request.job.id])

        if Rails.env == 'production'
          # envia email pro moderador avisando da CONS::REQUEST[:DESISTENCIA] e pros demais usuarios avisando da reabertura do plantao
          UserMailer.send_email_ownner_job(@request.job.id,current_user.id,CONS::REQUEST[:DESISTENCIA])
        end

        @cancelou = @request.job.id
        format.js
      else  
        @name = 'Seleção para esse Plantão já foi encerrada. Você não pode mais Desistir'
        format.js
      end
    end
  end

  protected
  # usuário só pode se candidatar se tiver créditos
  def pode_candidatar
    @job = Job.new
    @user =  User.find_by_id(current_user.id)
    if !@user.area.nil?
      if @user.credits <= 0 
        respond_to do |format|
          @name = 'Você não pode se candidatar em um plantão pois não possui créditos. Para continuar utilizando esse serviço, recarregue seus créditos.'
          format.js
          #format.html {  redirect_to @job, alert: 'Você não se candidatar em um plantão pois não possui créditos. Para continuar utilizando esse serviço, recarregue seus créditos.'}
        end 
      end
    else
      respond_to do |format|
        @redirect = edit_user_registration_url
        @name = 'Você não pode se candidatar em um plantão pois não possui créditos. Para continuar utilizando esse serviço, recarregue seus créditos.'
        format.js
      end
    end
  end

  def jobExpirou
    # verifica se plantao ja expirou
   
      @request = Request.new(params[:request])
      @job = Job.find(@request.job_id)
      p @job
      if @job.date <=  1.day.ago.localtime
        respond_to do |format|
        @name = 'O Plantão está fechado, a data expirou.'
        format.js 
      end 
     end 
  end

end
