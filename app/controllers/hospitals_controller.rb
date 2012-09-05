# -*- coding: utf-8 -*-
class HospitalsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new,:create,:edit]
  before_filter :load_cities  

  # GET /hospitals
  # GET /hospitals.json
  
  def index
    @hospital = Hospital.new
    
    if params[:hospital].nil?
      @hospitals = Hospital.paginate(:page => params[:page], :per_page => 3)
    elsif params[:hospital][:state_id]=="" and params[:hospital][:city_id]==""
      @hospitals = Hospital.paginate(:page => params[:page], :per_page => 3)
    else
      @hospitals = Hospital.paginate(:page => params[:page], :per_page => 3).find_all_by_state_id_and_city_id(params[:hospital][:state_id],params[:hospital][:city_id],:order => "hospitals.id")

    end 

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @hospitals }
    end
  end

  # GET /hospitals/1
  # GET /hospitals/1.json
  def show
    @hospital = Hospital.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hospital }
    end
  end

  # GET /hospitals/new
  # GET /hospitals/new.json
  def new
    @hospital = Hospital.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hospital }
    end
  end

  # GET /hospitals/1/edit
  def edit
    @hospital = Hospital.find(params[:id])
  end

  # POST /hospitals
  # POST /hospitals.json
  def create
    @hospital = Hospital.new(params[:hospital])

    respond_to do |format|
      if @hospital.save
        format.html { redirect_to @hospital, notice: 'Hospital Criado com Sucesso.' }
        format.json { render json: @hospital, status: :created, location: @hospital }
      else
        format.html { render action: "new" }
        format.json { render json: @hospital.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hospitals/1
  # PUT /hospitals/1.json
  def update
    @hospital = Hospital.find(params[:id])

    respond_to do |format|
      if @hospital.update_attributes(params[:hospital])
        format.html { redirect_to @hospital, notice: 'Hospital atualizado com Sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @hospital.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hospitals/1
  # DELETE /hospitals/1.json
  def destroy
    @hospital = Hospital.find(params[:id])
    @hospital.destroy

    respond_to do |format|
      format.html { redirect_to hospitals_url }
      format.json { head :no_content }
    end
  end


  

end
