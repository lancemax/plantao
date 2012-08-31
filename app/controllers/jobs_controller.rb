# -*- coding: utf-8 -*-
class JobsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new,:create,:edit]

	# GET /jobs
	# GET /jobs.json
	def index
    query = Job
    
  if !params[:job].nil?  && !params[:job][:hospital_id].nil?  && params[:job][:hospital_id] != ""
      query =  query.where("hospital_id = ?",params[:job][:hospital_id])
 	end

   if !params[:job].nil?  && !params[:job][:area_id].nil?  && params[:job][:area_id] != ""
      query =  query.where("area_id = ?",params[:job][:area_id])
   end

   if !params[:job].nil?  && !params[:job][:shift_id].nil?  && params[:job][:shift_id] != ""
      query =  query.where("shift_id = ?",params[:job][:shift_id])
   end

    @jobs = query.where(:date => 1.days.ago..Time.now+10.days).paginate(:page => params[:page], :per_page => 4).order("date")


  @request = Request.new
  @search = Job.new
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
    
	setMoney(params[:job][:price])

	if params[:job][:price].to_f <= 0.00
			  @name = "O valor não pode ser negativo "
	 			@sucesso = false
				return false
	end


	if params[:job][:price].to_f > 9999.99
		  @name = "O valor não pode ser maior que R$9.999,99 "
 			@sucesso = false
			return false
	end

	@job = Job.new(params[:job])
    @job.user_id = current_user.id
    @job.date = Time.now
    respond_to do |format|
      if @job.save
         UserMailer.send_emails(@job)
        format.html { redirect_to @job, notice: 'Plantão Criado com Sucesso.' }
        format.json { render json: @job, status: :created, location: @job }
      else
        format.html { render action: "new" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
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

	if params[:job][:price].to_f <= 0.00
			  @name = "O valor não pode ser negativo "
	 			@sucesso = false
				return false
	end


	if params[:job][:price].to_f > 9999.99
		  @name = "O valor não pode ser maior que R$9.999,99 "
 			@sucesso = false
			return false
	end

    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        UserMailer.send_emails(@job)
        format.html { redirect_to @job, notice: 'Plantão atualizado com Sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end


end
