  # -*- coding: utf-8 -*-
class JobsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new,:create,:edit]
  before_filter :pode_editar , :only => [:edit , :update]
  before_filter :pode_criar , :only => [:create,:new]
  before_filter :populaCombos , :only => [:index]

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
    @pagetitle = 'Plantões'
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
    #Não pega os jobs excluidos
    #query = query.where("request_id != 0")

    #pega jobs de hoje a 10 dias e faz a paginação
    query = query.where(:date => 1.days.ago..Time.now+10.days).paginate(:page => params[:page], :per_page => 6).order("date")

    @jobs = query

    #instancia para formulario de pegar plantão
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
    if user_signed_in?
      @eh_candidato = is_candidate(@job.id)
    end
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
        Request.update_all( ["status_request_id = ? " ,CONS::REQUEST[:CANCELADO] ], ["job_id = ?",@job.id])
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
        
        # troco a moeda
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
          format.html {  redirect_to @job, alert: 'O Plantão não pode ser editado pois possui um escolhido.É possível excluir o plantão.'}
        end
     end 
  end
  # valida se o usuário tem créditos para ceder um plantão
  def pode_criar
    @job = Job.new
    @user =  User.find_by_id(current_user.id)
    #@user = @user[0] 
    if !@user.area.nil? && !@user.crm.nil?
      if @user.credits <= 0 
          respond_to do |format|
            format.html {  redirect_to @job, alert: 'Você não pode Cadastrar um plantão pois você não possui créditos. Para continuar utilizando nossos serviços, recarregue seus créditos.'}
          end 
      end
    else
      respond_to do |format|
        format.html {  redirect_to edit_user_registration_url, alert: 'Você não pode Cadastrar um plantão pois você não completou o seu cadastro. preencha os dados abaixo'}
      end 
    end
  end

  def is_candidate(job_id)
    @candidato = Request.where(:user_id => current_user.id,:job_id =>job_id).first
    return @candidato
  end

  def populaCombos
    @states_array = State.all.map { |state| [state.name, state.id] }
  end

end
