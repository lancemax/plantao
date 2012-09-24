# -*- coding: utf-8 -*-
class JobsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new,:create,:edit]
  before_filter :pode_editar , :only => [:edit , :update]
  before_filter :pode_criar , :only => [:create]

  attr_accessor :diasSemana


  $diasSemana = [
    "domingo",
    "segunda",
    "terca",
    "quarta",
    "quinta",
    "sexta",
    "sabado",
    ]
	# GET /jobs
	# GET /jobs.json
	def index
    @job = Job.new
    query = Job
    
    #verifica se veio POST
    if !params[:job].nil?  

      #verifica se hospital veio pelo POST
      if !params[:job][:hospital_id].nil?  && params[:job][:hospital_id] != ""
        query =  query.where("hospital_id = ?",params[:job][:hospital_id])
      end
      #verifica se area veio pelo POST
      if !params[:job][:area_id].nil?  && params[:job][:area_id] != ""
        query =  query.where("area_id = ?",params[:job][:area_id])  
      end
      #verifica se shift veio pelo POST
      if !params[:job][:shift_id].nil?  && params[:job][:shift_id] != ""
        query =  query.where("shift_id = ?",params[:job][:shift_id])
      end
      #verifica se price veio pelo POST
      if !params[:job][:price].nil?  && params[:job][:price] != ""
        setMoney(params[:job][:price])
        query =  query.where("price >= ?",params[:job][:price])
      end    

    end
    
    # filtro dos dias da semana 
    $diasSemana.each do  |i|
 
      if !cookies[i].nil? &&  cookies[i] == "false"
         query = query.where("EXTRACT(dow from date) != ? ",$diasSemana.index(i))      
      end 
    end   

    query = query.where(:date => 1.days.ago..Time.now+10.days).paginate(:page => params[:page], :per_page => 8).order("date")

    @jobs = query


    @request = Request.new
    
  	respond_to do |format|
  	  format.html # index.html.erb
  	  format.json { render json: @jobs }
  	end
	end



  # GET /jobs/new
  # GET /jobs/new.json
  def new
    @job = Job.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job }
    end
  end

  # POST /jobs
  # POST /jobs.json
  def create
    if recaptcha_valid?
    	setMoney(params[:job][:price])

    	@job = Job.new(params[:job])
    	@job.user_id = current_user.id
    	#@job.date = Time.now
        respond_to do |format|
          if @job.save
            if Rails.env == 'production' 
              UserMailer.send_emails(@job) 
            end 
            format.html { redirect_to @job, notice: 'Plantão Criado com Sucesso.' }
            format.json { render json: @job, status: :created, location: @job }
          else
            format.html { render action: "new" }
            format.json { render json: @job.errors, status: :unprocessable_entity }
          end
        end
   else
      respond_to do |format|
      format.html { redirect_to new_job_path, alert: 'Captcha inválido.' }
      end
    end  
  end
	

   # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find(params[:id])
    @request = Request.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job }
    end
  end


 # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end
  # PUT /jobs/1
  # PUT /jobs/1.json
  def update
	setMoney(params[:job][:price])

    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        Request.update_all( ["status_request_id = ? " ,CONS::REQUEST[:CANCELADO] ], ["job_id = ?",@request.job.id])
        if Rails.env == 'production' 
          UserMailer.send_emails_edit(@job) 
        end 
        format.html { redirect_to @job, notice: 'Plantão atualizado com Sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job = Job.find(params[:id])
    
    @aceito  =  Request.find_all_by_job_id_and_status_request_id(params[:id], CONS::REQUEST[:ACEITO])
    respond_to do |format|
      if @aceito.count > 0
        # cancela todos os requests , consome credito do moderador , elege o mesmo e envia email para os pleitiados
        # troco a moeda
	p @job
	p @aceito
        @user = User.new
        @user.consume_credits(@job.user.id)
        @user.payback_credits(@aceito[0].user.id)
      end

      # cancela todos os requests
      Request.update_all(["status_request_id = ?", CONS::REQUEST[:CANCELADO] ] , ["job_id = ?", @job.id])
      
      # cancela o job, mudando o request eleito para 0 (zero)
      @job.cancel_job(@job.id)
      
      # manda email para os candidatos, avisando do cancelamento
      UserMailer.send_email_cancel_job(@job,@job.requests,@aceito[0])
	
	
      format.html { redirect_to @job, notice: 'Plantão Excluido com Sucesso.' }
      format.json { head :no_content }
	
    end
  end

  protected

  def pode_editar
    # verifica se existe algum escolhido nesse plantão
     @job = Job.find(params[:id])
     if !@job.request_id.nil?
        respond_to do |format|
          format.html {  redirect_to @job, notice: 'O Plantão não pode ser editado pois possui um escolhido.É possível excluir o plantão.'}
        end
     end 
  end
  # valida se o usuário tem créditos para ceder um plantão
  def pode_criar
    @user =  User.find_all_by_id(current_user.id)
    @user = @user[0] 
    if @user.credits >= 0 
      return true
    else
        respond_to do |format|
          format.html {  redirect_to @job, notice: 'Você não pode ceder um plantão pois está com um número negativo de créditos.Por favor coloque créditos e tente novamente.'}
          return false
        end 
    end
  end



end
