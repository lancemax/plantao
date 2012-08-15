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

  # GET /requests/1
  # GET /requests/1.json
  def show
    @request = Request.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @request }
    end
  end


  # GET /requests/1/edit
  def edit
    @request = Request.find(params[:id])
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(params[:request])
    @verifica = Request.where(:user_id => current_user.id,:job_id =>@request.job_id).first
    unless @verifica
      @request.user_id = current_user.id
      respond_to do |format|
        if @request.save
          @name='Você se candidatou a esse plantão com sucesso.'
          format.js
        else
          @name='Não foi possivel completar sua requisição'
        end
      end
    end 
     
  end

  # PUT /requests/1
  # PUT /requests/1.json
  def update
    @request = Request.find(params[:id])

    respond_to do |format|
      if @request.update_attributes(params[:request])
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request = Request.find(params[:id])
    #localiza o plantão referente a esse request
    @job = Job.find_by_id(@request.job_id)
    respond_to do |format|
      #caso o moderador ainda não tenho escolhido, ou ele escolheu um candidato diferente do current. então deleta
      if @job.request_id.nil?
        @request.uptdate(@request.id, :quit)
        @deletou = 'sim'
        format.js
      else
        @name = 'Seleção para esse Plantão já foi encerrada. Você não pode mais Desistir'
        format.js
      end
    end
  end
end
